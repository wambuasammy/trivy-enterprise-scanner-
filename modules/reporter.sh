#!/usr/bin/env bash

# ----------------------------------------------------------------------------
# Initialize Assessment Directory
# ----------------------------------------------------------------------------
init_assessment_dir() {
    local assessment_name="$1"

    CURRENT_ASSESSMENT_NAME="$assessment_name"
    CURRENT_ASSESSMENT_DIR="$REPORTS_DIR/$assessment_name"

    mkdir -p "$CURRENT_ASSESSMENT_DIR"
    rm -f "$CURRENT_ASSESSMENT_DIR"/*
}

# ----------------------------------------------------------------------------
# Get Current Assessment Directory
# ----------------------------------------------------------------------------
get_assessment_dir() {
    echo "$CURRENT_ASSESSMENT_DIR"
}

# ----------------------------------------------------------------------------
# Select Report Output Format
# ----------------------------------------------------------------------------
# REPORT_FORMAT values:
#   csv     -> Separate CSV reports only
#   excel   -> Combined Excel workbook only
#   both    -> CSV reports + Excel workbook
# ----------------------------------------------------------------------------
select_report_format() {
    # Preserve previously selected format during multi-engine runs
    if [[ -n "${REPORT_FORMAT:-}" ]]; then
        return
    fi

    echo
    echo "=============================================================="
    echo " Report Output Format"
    echo "=============================================================="
    echo " 1) Separate Reports (CSV files only)"
    echo " 2) Combined Excel Workbook (.xlsx)"
    echo " 3) Both"
    echo "=============================================================="

    read -rp "Select option [1]: " choice
    choice="${choice:-1}"

    case "$choice" in
        1) REPORT_FORMAT="csv" ;;
        2) REPORT_FORMAT="excel" ;;
        3) REPORT_FORMAT="both" ;;
        *) REPORT_FORMAT="csv" ;;
    esac
}

# ----------------------------------------------------------------------------
# Generate Combined Excel Workbook
# ----------------------------------------------------------------------------
generate_excel_report() {
    local assessment_dir="$1"
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    case "${REPORT_FORMAT:-csv}" in
        csv)
            # CSV-only mode; no workbook generated
            return
            ;;
        excel|both)
            python3 "$script_dir/excel_reporter.py" "$assessment_dir" >/dev/null
            ;;
    esac
}
