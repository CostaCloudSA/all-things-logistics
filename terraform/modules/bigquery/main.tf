# BigQuery Domain-Driven Data Mesh Module
# Implements domain-specific datasets and schema tables with mandatory descriptions

# 1. Domain Dataset: Customs Compliance
resource "google_bigquery_dataset" "ds_customs_compliance" {
  project     = var.project_id
  dataset_id  = "ds_customs_compliance"
  location    = var.region
  description = "Master repository of Harmonized System codes, tariff rates, De Minimis rules, and sanitary permit matrices across the Americas."

  labels = {
    domain      = "customs-compliance"
    environment = var.environment
  }
}

# Table: HS Codes Catalog
resource "google_bigquery_table" "hs_codes_v2022" {
  project     = var.project_id
  dataset_id  = google_bigquery_dataset.ds_customs_compliance.dataset_id
  table_id    = "hs_codes_v2022"
  description = "Global WCO Harmonized System 6-to-10 digit tariff taxonomy and commodity classifications."

  clustering = ["destination_iso", "hs_code_root"]

  schema = jsonencode([
    {
      name        = "hs_code"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "Full 6 to 10-digit Harmonized System tariff code (e.g., 0207.14.00)."
    },
    {
      name        = "hs_code_root"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "4 to 6-digit root HS chapter/subheading (e.g., 0207)."
    },
    {
      name        = "destination_iso"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "2-letter ISO 3166-1 alpha-2 destination country code (e.g., US, MX, CO, BR)."
    },
    {
      name        = "description_en"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "Official English commodity description."
    },
    {
      name        = "description_es"
      type        = "STRING"
      mode        = "NULLABLE"
      description = "Official Spanish commodity description."
    },
    {
      name        = "ad_valorem_rate"
      type        = "NUMERIC"
      mode        = "REQUIRED"
      description = "Standard Most Favored Nation (MFN) import duty percentage rate (e.g., 5.0 for 5%)."
    },
    {
      name        = "vat_rate"
      type        = "NUMERIC"
      mode        = "REQUIRED"
      description = "Applicable national Value Added Tax (VAT / IVA / ICMS) percentage rate."
    },
    {
      name        = "requires_sanitary_permit"
      type        = "BOOLEAN"
      mode        = "REQUIRED"
      description = "Flag indicating if agricultural, sanitary, or phytosanitary health clearance is mandatory."
    }
  ])
}

# Table: Country De Minimis Rules
resource "google_bigquery_table" "country_de_minimis" {
  project     = var.project_id
  dataset_id  = google_bigquery_dataset.ds_customs_compliance.dataset_id
  table_id    = "country_de_minimis"
  description = "De Minimis import value thresholds below which goods enter duty-free and tax-free."

  schema = jsonencode([
    {
      name        = "country_iso"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "2-letter ISO 3166-1 alpha-2 country code."
    },
    {
      name        = "country_name"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "Full sovereign nation name."
    },
    {
      name        = "duty_de_minimis_usd"
      type        = "NUMERIC"
      mode        = "REQUIRED"
      description = "Maximum shipment value in USD exempt from import tariffs."
    },
    {
      name        = "tax_de_minimis_usd"
      type        = "NUMERIC"
      mode        = "REQUIRED"
      description = "Maximum shipment value in USD exempt from sales tax / VAT."
    },
    {
      name        = "notes"
      type        = "STRING"
      mode        = "NULLABLE"
      description = "Regulatory decree and special customs condition notes."
    }
  ])
}

# 2. Domain Dataset: Shipments & Declarations
resource "google_bigquery_dataset" "ds_shipments_declarations" {
  project     = var.project_id
  dataset_id  = "ds_shipments_declarations"
  location    = var.region
  description = "Transactional Golden Documents, entry summaries, Pedimentos, DUCAs, and DUImps."

  labels = {
    domain      = "shipments-declarations"
    environment = var.environment
  }
}

# Table: Entry Summaries (CBP Form 7501 & Regional Golden Docs)
resource "google_bigquery_table" "customs_declarations" {
  project     = var.project_id
  dataset_id  = google_bigquery_dataset.ds_shipments_declarations.dataset_id
  table_id    = "customs_declarations"
  description = "Master ledger of validated customs entries and generated Golden Documents."

  time_partitioning {
    type  = "DAY"
    field = "created_at"
  }

  clustering = ["destination_iso", "origin_iso", "declaration_status"]

  schema = jsonencode([
    {
      name        = "declaration_id"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "Unique UUID for the customs declaration transaction."
    },
    {
      name        = "document_type"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "Canonical Golden Document type (e.g., CBP_7501, PEDIMENTO_3_0, DUCA_D, DUIMP, FORM_500)."
    },
    {
      name        = "origin_iso"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "2-letter ISO origin country."
    },
    {
      name        = "destination_iso"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "2-letter ISO destination country."
    },
    {
      name        = "importer_tax_id"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "Masked or tokenized importer of record identification number."
    },
    {
      name        = "total_declared_value_usd"
      type        = "NUMERIC"
      mode        = "REQUIRED"
      description = "Total commercial shipment value in USD."
    },
    {
      name        = "calculated_duty_usd"
      type        = "NUMERIC"
      mode        = "REQUIRED"
      description = "Total calculated import duty in USD."
    },
    {
      name        = "calculated_vat_usd"
      type        = "NUMERIC"
      mode        = "REQUIRED"
      description = "Total calculated sales tax / VAT in USD."
    },
    {
      name        = "declaration_status"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "Current clearance state (e.g., DRAFT, VALIDATED, FILED, PENDING_SANIS, FLAGGED_REVIEW)."
    },
    {
      name        = "payload_json"
      type        = "STRING"
      mode        = "REQUIRED"
      description = "Complete structured JSON payload conforming to local customs electronic platform specs."
    },
    {
      name        = "created_at"
      type        = "TIMESTAMP"
      mode        = "REQUIRED"
      description = "Record generation timestamp."
    }
  ])
}

# 3. Domain Dataset: Trade Agreements
resource "google_bigquery_dataset" "ds_trade_agreements" {
  project     = var.project_id
  dataset_id  = "ds_trade_agreements"
  location    = var.region
  description = "Preferential free trade agreement rules of origin and duty reduction schedules across the Americas."

  labels = {
    domain      = "trade-agreements"
    environment = var.environment
  }
}

# 4. Domain Dataset: BigQuery MCP & NLP Semantic Views
resource "google_bigquery_dataset" "ds_mcp_nlp_views" {
  project     = var.project_id
  dataset_id  = "ds_mcp_nlp_views"
  location    = var.region
  description = "Curated, flattened semantic views for BigQuery MCP Tool discovery and natural language SQL translation."

  labels = {
    domain      = "mcp-nlp-views"
    environment = var.environment
  }
}

# Semantic View for MCP: Active Customs Status Summary
resource "google_bigquery_table" "v_active_declarations_summary" {
  project     = var.project_id
  dataset_id  = google_bigquery_dataset.ds_mcp_nlp_views.dataset_id
  table_id    = "v_active_declarations_summary"
  description = "Semantic summary view of active customs declarations and duty obligations for MCP agent querying."

  view {
    query          = <<EOF
SELECT
  declaration_id,
  document_type,
  origin_iso,
  destination_iso,
  total_declared_value_usd,
  calculated_duty_usd,
  calculated_vat_usd,
  declaration_status,
  created_at
FROM
  `${var.project_id}.${google_bigquery_dataset.ds_shipments_declarations.dataset_id}.customs_declarations`
EOF
    use_legacy_sql = false
  }
}
