#!/usr/bin/env bash
set -eu

mkdir -p .trivy/reports .trivy/summary

PYTHON_BIN=""
if command -v python3 >/dev/null 2>&1; then
    PYTHON_BIN="python3"
elif command -v python >/dev/null 2>&1; then
    PYTHON_BIN="python"
fi

if [ -z "$PYTHON_BIN" ]; then
  if ! command -v jq >/dev/null 2>&1; then
    cat > .trivy/summary/summary.md <<'MD'
# Trivy image scan summary

Summary generation skipped because neither Python nor jq is available in this build agent.

  Raw Trivy reports are still archived under `.trivy/reports/`.
MD

    cat > .trivy/summary/index.html <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Trivy image scan summary</title>
  <style>
  body { font-family: Arial, sans-serif; margin: 2rem; background: #f7f9fc; color: #1f2937; }
  .notice { border-radius: 12px; padding: 1rem 1.2rem; background: #fff7ed; border: 1px solid #fed7aa; }
  </style>
</head>
<body>
  <h1>Trivy image scan summary</h1>
  <div class="notice">
  Summary generation skipped because neither <code>python3</code>/<code>python</code> nor <code>jq</code> is available in this build agent.<br />
  Raw Trivy reports are still archived under <code>.trivy/reports/</code>.
  </div>
</body>
</html>
HTML

    echo "Trivy summary generated in minimal fallback mode (Python/jq unavailable)."
    exit 0
  fi

  html_escape() {
    jq -Rn --arg s "$1" '$s|@html'
  }

  rows_file="$(mktemp)"
  trap 'rm -f "$rows_file"' EXIT

  while IFS= read -r json_path; do
    rel_json="${json_path#./}"
    image_name="$(basename "${rel_json%.json}")"
    report_txt_path="${rel_json%.json}.txt"
    report_name="$(basename "$report_txt_path")"
    report_txt="reports/$report_name"
    if [ ! -f "$report_txt_path" ]; then
      report_txt=""
    fi

    if jq empty "$json_path" >/dev/null 2>&1; then
      high="$(jq '[.Results[]?.Vulnerabilities[]? | select((.Severity // "UNKNOWN" | ascii_upcase) == "HIGH")] | length' "$json_path")"
      critical="$(jq '[.Results[]?.Vulnerabilities[]? | select((.Severity // "UNKNOWN" | ascii_upcase) == "CRITICAL")] | length' "$json_path")"
      total="$(jq '[.Results[]?.Vulnerabilities[]?] | length' "$json_path")"
    else
      high="0"
      critical="0"
      total="0"
    fi

    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$image_name" "$high" "$critical" "$total" "$report_txt" "$rel_json" >> "$rows_file"
  done < <(find . -type f -path './.trivy/reports/*.json' | sort)

  sorted_rows="$(mktemp)"
  trap 'rm -f "$rows_file" "$sorted_rows"' EXIT
  if [ -s "$rows_file" ]; then
    sort -t $'\t' -k3,3nr -k2,2nr -k4,4nr "$rows_file" > "$sorted_rows"
  else
    : > "$sorted_rows"
  fi

  images_scanned="0"
  images_with_findings="0"
  high_total="0"
  critical_total="0"

  while IFS=$'\t' read -r image_name high critical total report_txt rel_json; do
    [ -n "${image_name:-}" ] || continue
    images_scanned=$((images_scanned + 1))
    high_total=$((high_total + high))
    critical_total=$((critical_total + critical))
    if [ "$total" -gt 0 ]; then
      images_with_findings=$((images_with_findings + 1))
    fi
  done < "$sorted_rows"

  {
    echo '# Trivy image scan summary'
    echo
    echo "- Images scanned: $images_scanned"
    echo "- Images with findings: $images_with_findings"
    echo "- Total HIGH findings: $high_total"
    echo "- Total CRITICAL findings: $critical_total"
    echo
    echo '| Image | HIGH | CRITICAL | Total | Report |'
    echo '| --- | ---: | ---: | ---: | --- |'

    while IFS=$'\t' read -r image_name high critical total report_txt rel_json; do
      [ -n "${image_name:-}" ] || continue
      if [ -n "$report_txt" ]; then
        report_cell="[txt]($report_txt)"
      else
        report_cell='n/a'
      fi
      echo "| $image_name | $high | $critical | $total | $report_cell |"

      if [ -f "$rel_json" ]; then
        echo
        echo "## $image_name"
        echo
        echo '| Severity | Count |'
        echo '| --- | ---: |'
        echo "| HIGH | $high |"
        echo "| CRITICAL | $critical |"
        echo "| Total | $total |"

        details_count="$(jq '[.Results[]?.Vulnerabilities[]?] | length' "$rel_json" 2>/dev/null || echo 0)"
        if [ "$details_count" -gt 0 ]; then
          echo
          echo '| Package | Severity | Title | Fixed Version |'
          echo '| --- | --- | --- | --- |'
          jq -r '
            [.Results[]?.Vulnerabilities[]? | {
            severity: ((.Severity // "UNKNOWN") | ascii_upcase),
            package: (.PkgName // "Unknown"),
            title: (.Title // "Unknown vulnerability"),
            fixed: (.FixedVersion // "-")
            }]
            | sort_by(
                if .severity == "CRITICAL" then 0
                elif .severity == "HIGH" then 1
                elif .severity == "MEDIUM" then 2
                elif .severity == "LOW" then 3
                else 4 end,
                .package,
                .title
              )
            | .[:10]
            | .[]
            | [.package, .severity, .title, .fixed]
            | @tsv
          ' "$rel_json" | while IFS=$'\t' read -r pkg sev title fixed; do
            echo "| $pkg | $sev | $title | $fixed |"
          done
        fi
      fi
      echo
    done < "$sorted_rows"
  } > .trivy/summary/summary.md

  if [ "$critical_total" -gt 0 ]; then
    banner_class='banner-critical'
    banner_text='CRITICAL findings detected across the image set.'
  elif [ "$high_total" -gt 0 ]; then
    banner_class='banner-ok'
    banner_text='No CRITICAL findings detected; HIGH findings are listed below.'
  else
    banner_class='banner-ok'
    banner_text='No vulnerabilities detected in the current scan set.'
  fi

  {
    cat <<HTML_HEAD
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Trivy image scan summary</title>
  <style>
  body { font-family: Arial, sans-serif; margin: 2rem; background: #f7f9fc; color: #1f2937; }
  h1 { margin-bottom: 0.5rem; }
  .banner { border-radius: 12px; padding: 1rem 1.2rem; margin: 1rem 0 1.5rem; font-weight: 700; border: 1px solid transparent; }
  .banner-critical { background: #fff0f0; color: #7f1d1d; border-color: #f7b2b2; }
  .banner-ok { background: #edfdf2; color: #14532d; border-color: #b7eac0; }
  .kpis { display: flex; gap: 1rem; flex-wrap: wrap; margin: 1.5rem 0; }
  .kpi { min-width: 180px; padding: 1rem 1.25rem; border-radius: 10px; border: 1px solid #dbe1ea; background: white; box-shadow: 0 1px 2px rgba(0,0,0,0.04); }
  .kpi .label { font-size: 0.8rem; color: #52607a; text-transform: uppercase; letter-spacing: 0.05em; }
  .kpi .value { font-size: 1.8rem; font-weight: 700; margin-top: .4rem; }
  table { border-collapse: collapse; width: 100%; background: white; }
  th, td { border: 1px solid #dbe1ea; padding: 0.7rem 0.8rem; text-align: left; vertical-align: top; }
  th { background: #eef3ff; }
  .image-cell { display: flex; justify-content: space-between; align-items: center; gap: 0.5rem; }
  .status { display: inline-block; padding: 0.2rem 0.55rem; border-radius: 999px; font-size: 0.72rem; letter-spacing: 0.04em; font-weight: 700; }
  .status-critical { background: #f8d7da; color: #7f1d1d; }
  .status-high { background: #fff3cd; color: #7a4b00; }
  .status-clean { background: #d1fae5; color: #065f46; }
  .badge { display: inline-block; min-width: 2rem; text-align: center; padding: 0.22rem 0.45rem; border-radius: 999px; font-weight: 700; }
  .badge-high { background: #fff4d6; color: #7a4b00; }
  .badge-critical { background: #ffe2e2; color: #7f1d1d; }
  .badge-medium { background: #dbeafe; color: #1d4ed8; }
  .badge-unknown { background: #e5e7eb; color: #374151; }
  .detail-table { margin-top: 0.5rem; font-size: 0.9rem; }
  a { color: #0b57d0; text-decoration: none; }
  a:hover { text-decoration: underline; }
  details { margin-top: 0.5rem; }
  summary { cursor: pointer; font-weight: 600; margin-bottom: 0.5rem; }
  </style>
</head>
<body>
  <h1>Trivy image scan summary</h1>
  <div class="banner $banner_class">$banner_text</div>
  <div class="kpis">
  <div class="kpi"><div class="label">Images scanned</div><div class="value">$images_scanned</div></div>
  <div class="kpi"><div class="label">Images with findings</div><div class="value">$images_with_findings</div></div>
  <div class="kpi"><div class="label">HIGH</div><div class="value">$high_total</div></div>
  <div class="kpi"><div class="label">CRITICAL</div><div class="value">$critical_total</div></div>
  </div>
  <table>
  <thead>
    <tr><th>Image</th><th>HIGH</th><th>CRITICAL</th><th>Total</th><th>Report</th></tr>
  </thead>
  <tbody>
HTML_HEAD

    if [ "$images_scanned" -eq 0 ]; then
      echo '      <tr><td colspan="5">No Trivy reports were found.</td></tr>'
    else
      while IFS=$'\t' read -r image_name high critical total report_txt rel_json; do
        [ -n "${image_name:-}" ] || continue
        safe_image="$(html_escape "$image_name")"
        if [ "$critical" -gt 0 ]; then
          row_color='#ffebeb'
          status_class='status-critical'
          status_text='CRITICAL'
        elif [ "$high" -gt 0 ]; then
          row_color='#fff3db'
          status_class='status-high'
          status_text='HIGH'
        else
          row_color='#ebf9ee'
          status_class='status-clean'
          status_text='CLEAN'
        fi

        if [ -n "$report_txt" ]; then
          safe_report="$(html_escape "$report_txt")"
          report_link="<a href=\"../$safe_report\">$safe_report</a>"
        else
          report_link='n/a'
        fi

        echo "      <tr style=\"background:$row_color;\"><td><div class=\"image-cell\"><strong>$safe_image</strong><span class=\"status $status_class\">$status_text</span></div></td><td><span class=\"badge badge-high\">$high</span></td><td><span class=\"badge badge-critical\">$critical</span></td><td>$total</td><td>$report_link</td></tr>"

        if [ -f "$rel_json" ] && [ "$total" -gt 0 ]; then
          echo '      <tr><td colspan="5">'
          echo '        <details><summary>Top findings</summary>'
          echo '          <table class="detail-table"><thead><tr><th>Severity</th><th>Package</th><th>Title</th><th>Fixed</th></tr></thead><tbody>'
          jq -r '
            [.Results[]?.Vulnerabilities[]? | {
            severity: ((.Severity // "UNKNOWN") | ascii_upcase),
            package: (.PkgName // "Unknown"),
            title: (.Title // "Unknown vulnerability"),
            fixed: (.FixedVersion // "-")
            }]
            | .[:10]
            | .[]
            | [.severity, .package, .title, .fixed]
            | @tsv
          ' "$rel_json" | while IFS=$'\t' read -r sev pkg title fixed; do
            safe_sev="$(html_escape "$sev")"
            safe_pkg="$(html_escape "$pkg")"
            safe_title="$(html_escape "$title")"
            safe_fixed="$(html_escape "$fixed")"
            sev_class='badge-unknown'
            if [ "$sev" = 'CRITICAL' ]; then
              sev_class='badge-critical'
            elif [ "$sev" = 'HIGH' ]; then
              sev_class='badge-high'
            elif [ "$sev" = 'MEDIUM' ]; then
              sev_class='badge-medium'
            fi
            echo "            <tr><td><span class=\"badge $sev_class\">$safe_sev</span></td><td>$safe_pkg</td><td>$safe_title</td><td>$safe_fixed</td></tr>"
          done
          echo '          </tbody></table>'
          echo '        </details>'
          echo '      </td></tr>'
        fi
      done < "$sorted_rows"
    fi

    cat <<'HTML_FOOT'
  </tbody>
  </table>
</body>
</html>
HTML_FOOT
  } > .trivy/summary/index.html

  echo "Trivy summary generated with jq fallback (Python unavailable)."
  exit 0
fi

"$PYTHON_BIN" - <<'PY'
import json
from pathlib import Path
from html import escape

root = Path('.')
json_reports = sorted(root.glob('.trivy/reports/*.json'))
summary_rows = []
markdown_sections = []

for json_path in json_reports:
    txt_path = json_path.with_suffix('.txt')
    rel_txt = f"reports/{txt_path.name}" if txt_path.exists() else ''
    image_name = json_path.name.replace('.json', '')

    try:
        with json_path.open('r', encoding='utf-8') as fh:
            data = json.load(fh)
    except (json.JSONDecodeError, OSError):
        summary_rows.append({
            'image': image_name,
            'high': 0,
            'critical': 0,
            'total': 0,
            'report': rel_txt,
            'details': [],
            'findings': False,
        })
        continue

    sev_counts = {'CRITICAL': 0, 'HIGH': 0, 'MEDIUM': 0, 'LOW': 0, 'UNKNOWN': 0}
    details = []
    for result in data.get('Results', []):
        for vuln in result.get('Vulnerabilities', []):
            sev = str(vuln.get('Severity', 'UNKNOWN')).upper()
            sev_counts[sev] = sev_counts.get(sev, 0) + 1
            details.append({
                'severity': sev,
                'package': str(vuln.get('PkgName', 'Unknown')),
                'title': str(vuln.get('Title', 'Unknown vulnerability')),
                'fixed': str(vuln.get('FixedVersion', '-')),
                'url': str(vuln.get('PrimaryURL', '')),
            })

          severity_rank = {'CRITICAL': 0, 'HIGH': 1, 'MEDIUM': 2, 'LOW': 3, 'UNKNOWN': 4}
          details.sort(key=lambda entry: (severity_rank.get(entry['severity'], 4), entry['package'], entry['title']))

    total = sum(sev_counts.values())
    findings = total > 0
    summary_rows.append({
        'image': image_name,
        'high': sev_counts.get('HIGH', 0),
        'critical': sev_counts.get('CRITICAL', 0),
        'total': total,
        'report': rel_txt,
        'details': details[:10],
        'findings': findings,
    })

    markdown_sections.append(
        f"## {image_name}\n\n| Severity | Count |\n| --- | ---: |\n| HIGH | {sev_counts.get('HIGH', 0)} |\n| CRITICAL | {sev_counts.get('CRITICAL', 0)} |\n| Total | {total} |\n"
    )
    if details:
        markdown_sections.append("| Package | Severity | Title | Fixed Version |\n| --- | --- | --- | --- |")
        for entry in details[:10]:
            markdown_sections.append(f"| {entry['package']} | {entry['severity']} | {entry['title']} | {entry['fixed']} |")
        markdown_sections.append('')

summary_md = Path('.trivy/summary/summary.md')
summary_md.parent.mkdir(exist_ok=True)
summary_rows.sort(key=lambda row: (row['critical'], row['high'], row['total']), reverse=True)

lines = [
    '# Trivy image scan summary',
    '',
    f"- Images scanned: {len(summary_rows)}",
    f"- Images with findings: {sum(1 for row in summary_rows if row['findings'])}",
    f"- Total HIGH findings: {sum(row['high'] for row in summary_rows)}",
    f"- Total CRITICAL findings: {sum(row['critical'] for row in summary_rows)}",
    '',
    '| Image | HIGH | CRITICAL | Total | Report |',
    '| --- | ---: | ---: | ---: | --- |',
]
for row in summary_rows:
    report_cell = f"[txt](../{row['report']})" if row['report'] else 'n/a'
    lines.append(f"| {row['image']} | {row['high']} | {row['critical']} | {row['total']} | {report_cell} |")
lines.extend(['', *markdown_sections])
summary_md.write_text('\n'.join(lines) + '\n', encoding='utf-8')

html_rows = []
for row in summary_rows:
    row_color = '#ffebeb' if row['critical'] else ('#fff3db' if row['high'] else '#ebf9ee')
    status_text = 'critical' if row['critical'] else ('high' if row['high'] else 'clean')
    details_html = ''
    if row['details']:
        detail_rows = ''.join(
            f"<tr><td><span class='badge badge-{entry['severity'].lower()}'>{escape(entry['severity'])}</span></td><td>{escape(entry['package'])}</td><td>{escape(entry['title'])}</td><td>{escape(entry['fixed'])}</td></tr>"
            for entry in row['details']
        )
        details_html = (
            "<details><summary>Top findings</summary>"
            "<table class='detail-table'><thead><tr><th>Severity</th><th>Package</th><th>Title</th><th>Fixed</th></tr></thead><tbody>"
            f"{detail_rows}</tbody></table></details>"
        )
    report_link = f'<a href="../{escape(row["report"]) if row["report"] else "#"}">{escape(row["report"])}</a>' if row['report'] else 'n/a'
    html_rows.append(
        f"<tr style='background:{row_color};'><td><div class='image-cell'><strong>{escape(row['image'])}</strong><span class='status status-{status_text}'>{status_text.upper()}</span></div></td><td><span class='badge badge-high'>{row['high']}</span></td><td><span class='badge badge-critical'>{row['critical']}</span></td><td>{row['total']}</td><td>{report_link}</td></tr>{details_html}"
    )

critical_total = sum(row['critical'] for row in summary_rows)
high_total = sum(row['high'] for row in summary_rows)
banner_class = 'banner-critical' if critical_total else 'banner-ok'

html = f'''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Trivy image scan summary</title>
  <style>
    body {{ font-family: Arial, sans-serif; margin: 2rem; background: #f7f9fc; color: #1f2937; }}
    h1 {{ margin-bottom: 0.5rem; }}
    .banner {{ border-radius: 12px; padding: 1rem 1.2rem; margin: 1rem 0 1.5rem; font-weight: 700; border: 1px solid transparent; }}
    .banner-critical {{ background: #fff0f0; color: #7f1d1d; border-color: #f7b2b2; }}
    .banner-ok {{ background: #edfdf2; color: #14532d; border-color: #b7eac0; }}
    .kpis {{ display: flex; gap: 1rem; flex-wrap: wrap; margin: 1.5rem 0; }}
    .kpi {{ min-width: 180px; padding: 1rem 1.25rem; border-radius: 10px; border: 1px solid #dbe1ea; background: white; box-shadow: 0 1px 2px rgba(0,0,0,0.04); }}
    .kpi .label {{ font-size: 0.8rem; color: #52607a; text-transform: uppercase; letter-spacing: 0.05em; }}
    .kpi .value {{ font-size: 1.8rem; font-weight: 700; margin-top: .4rem; }}
    table {{ border-collapse: collapse; width: 100%; background: white; }}
    th, td {{ border: 1px solid #dbe1ea; padding: 0.7rem 0.8rem; text-align: left; vertical-align: top; }}
    th {{ background: #eef3ff; }}
    .image-cell {{ display: flex; justify-content: space-between; align-items: center; gap: 0.5rem; }}
    .status {{ display: inline-block; padding: 0.2rem 0.55rem; border-radius: 999px; font-size: 0.72rem; letter-spacing: 0.04em; font-weight: 700; }}
    .status-critical {{ background: #f8d7da; color: #7f1d1d; }}
    .status-high {{ background: #fff3cd; color: #7a4b00; }}
    .status-clean {{ background: #d1fae5; color: #065f46; }}
    .badge {{ display: inline-block; min-width: 2rem; text-align: center; padding: 0.22rem 0.45rem; border-radius: 999px; font-weight: 700; }}
    .badge-high {{ background: #fff4d6; color: #7a4b00; }}
    .badge-critical {{ background: #ffe2e2; color: #7f1d1d; }}
    .badge-medium {{ background: #dbeafe; color: #1d4ed8; }}
    .badge-unknown {{ background: #e5e7eb; color: #374151; }}
    .detail-table {{ margin-top: 0.5rem; font-size: 0.9rem; }}
    a {{ color: #0b57d0; text-decoration: none; }}
    a:hover {{ text-decoration: underline; }}
    details {{ margin-top: 0.5rem; }}
    summary {{ cursor: pointer; font-weight: 600; margin-bottom: 0.5rem; }}
  </style>
</head>
<body>
  <h1>Trivy image scan summary</h1>
  <div class="banner {banner_class}">
    {('CRITICAL findings detected across the image set.' if critical_total else 'No CRITICAL findings detected; HIGH findings are listed below.') if critical_total or high_total else 'No vulnerabilities detected in the current scan set.'}
  </div>
  <div class="kpis">
    <div class="kpi"><div class="label">Images scanned</div><div class="value">{len(summary_rows)}</div></div>
    <div class="kpi"><div class="label">Images with findings</div><div class="value">{sum(1 for row in summary_rows if row['findings'])}</div></div>
    <div class="kpi"><div class="label">HIGH</div><div class="value">{high_total}</div></div>
    <div class="kpi"><div class="label">CRITICAL</div><div class="value">{critical_total}</div></div>
  </div>

  <table>
    <thead>
      <tr><th>Image</th><th>HIGH</th><th>CRITICAL</th><th>Total</th><th>Report</th></tr>
    </thead>
    <tbody>
      {''.join(html_rows) if html_rows else '<tr><td colspan="5">No Trivy reports were found.</td></tr>'}
    </tbody>
  </table>
</body>
</html>
'''
Path('.trivy/summary/index.html').write_text(html, encoding='utf-8')
PY
