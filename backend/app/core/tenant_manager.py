"""
Multi-Tenant Profile & Cryptographic Identity Manager.

Provides white-labeled tenant profiles, corporate branding themes,
and sovereign Ed25519 public key registries for the multi-agent customs fleet.

Supported Logistics Personas:
1. Campabadal Global Logistics (3PL International Freight Forwarder - Ocean Cyan/Navy theme #0284C7)
2. Transportes Tomas (Cross-Border Motor Carrier & Drayage Relay - Vibrant Crimson/Red theme #DC2626)
3. Agroexport Costa Rica (Enterprise Agricultural Shipper - Emerald Green theme #059669)
"""

from typing import Dict, List, Optional
from app.models.schemas import TenantProfile, TenantType


class TenantManager:
    """
    Manages white-labeled logistics tenant profiles, branding assets,
    statutory identification codes, and sovereign Ed25519 cryptographic public keys.
    """

    def __init__(self) -> None:
        """Initializes the tenant catalog with pre-configured logistics enterprise profiles."""
        self._tenants: Dict[str, TenantProfile] = {
            "tenant-campabadal": TenantProfile(
                tenant_id="tenant-campabadal",
                org_name="Campabadal Global Logistics",
                org_type=TenantType.MULTINATIONAL_FORWARDER,
                tagline="Autonomous AI Multi-Agent Cross-Border Fleet",
                brand_color_hex="#0284C7",  # Ocean Cyan/Blue
                accent_color_hex="#38BDF8",
                logo_icon="public",
                scac_or_dot_code="CPBD",
                tax_identifier="EIN-82-9918231",
                public_key_ed25519_hex="7d79b29e08bb8864758d4a974b2fcf7b328701ec749e4726cd5cc3ac5ec4c7aa",
                default_origin_iso="US",
                default_destination_iso="GT",
            ),
            "tenant-tomas": TenantProfile(
                tenant_id="tenant-tomas",
                org_name="Transportes Tomas",
                org_type=TenantType.REGIONAL_CARRIER,
                tagline="Cross-Border Drayage & Heavy Transload Relays",
                brand_color_hex="#DC2626",  # Vibrant Red
                accent_color_hex="#EF4444",
                logo_icon="local_shipping",
                scac_or_dot_code="SCT-MX-99421",
                tax_identifier="RFC-TTOM890412-9A2",
                public_key_ed25519_hex="8a543f45610815418a0ebca758e5e8e815779ec19d67568579cf441e8e50b134",
                default_origin_iso="MX",
                default_destination_iso="GT",
            ),
            "tenant-agroexport-cr": TenantProfile(
                tenant_id="tenant-agroexport-cr",
                org_name="Agroexport Costa Rica",
                org_type=TenantType.ENTERPRISE_SHIPPER,
                tagline="Perishables Cold-Chain & Controlled Atmosphere Transit",
                brand_color_hex="#059669",  # Emerald Green
                accent_color_hex="#10B981",
                logo_icon="eco",
                scac_or_dot_code="PROCOMER-CR-88214",
                tax_identifier="NIT-3-101-890214",
                public_key_ed25519_hex="9b65f3a0c5c490ef76ab41e411b012437648102a0bb89a1945a0b721ea1087bc",
                default_origin_iso="CR",
                default_destination_iso="US",
            ),
            "tenant-naviera-don-jorge": TenantProfile(
                tenant_id="tenant-naviera-don-jorge",
                org_name="Naviera Don Jorge",
                org_type=TenantType.OCEAN_CARRIER,
                tagline="Maritime Feeder & Intermodal Terminal Operations",
                brand_color_hex="#1E3A8A",  # Deep Maritime Navy
                accent_color_hex="#F59E0B",  # Amber Gold
                logo_icon="directions_boat",
                scac_or_dot_code="NDJ-992140",
                tax_identifier="IMO-9921408",
                public_key_ed25519_hex="a719c834ef1209b531dc18f92e4091a1005bc18a729e8c459810a9018bc799f2",
                default_origin_iso="CR",
                default_destination_iso="US",
            ),
            # Aliases for backward compatibility with existing integration tests
            "tenant-tecun": TenantProfile(
                tenant_id="tenant-tomas",
                org_name="Transportes Tomas",
                org_type=TenantType.REGIONAL_CARRIER,
                tagline="Cross-Border Drayage & Heavy Transload Relays",
                brand_color_hex="#DC2626",  # Vibrant Red
                accent_color_hex="#EF4444",
                logo_icon="local_shipping",
                scac_or_dot_code="SCT-MX-99421",
                tax_identifier="RFC-TTOM890412-9A2",
                public_key_ed25519_hex="8a543f45610815418a0ebca758e5e8e815779ec19d67568579cf441e8e50b134",
                default_origin_iso="MX",
                default_destination_iso="GT",
            ),
            "tenant-agroexport": TenantProfile(
                tenant_id="tenant-agroexport-cr",
                org_name="Agroexport Costa Rica",
                org_type=TenantType.ENTERPRISE_SHIPPER,
                tagline="Perishables Cold-Chain & Controlled Atmosphere Transit",
                brand_color_hex="#059669",  # Emerald Green
                accent_color_hex="#10B981",
                logo_icon="eco",
                scac_or_dot_code="PROCOMER-CR-88214",
                tax_identifier="NIT-3-101-890214",
                public_key_ed25519_hex="9b65f3a0c5c490ef76ab41e411b012437648102a0bb89a1945a0b721ea1087bc",
                default_origin_iso="CR",
                default_destination_iso="US",
            ),
        }

    def list_tenants(self) -> List[TenantProfile]:
        """
        Returns a list of the 4 primary white-labeled logistics tenant profiles.

        Returns:
            List[TenantProfile]: Catalog of Campabadal Global, Transportes Tomas, Agroexport Costa Rica, and Naviera Don Jorge.
        """
        primary_keys = ["tenant-campabadal", "tenant-tomas", "tenant-agroexport-cr", "tenant-naviera-don-jorge"]
        return [self._tenants[k] for k in primary_keys if k in self._tenants]

    def get_tenant(self, tenant_id: Optional[str]) -> TenantProfile:
        """
        Retrieves the TenantProfile for a given tenant ID with fallback to Campabadal Global.

        Args:
            tenant_id (Optional[str]): Unique tenant identifier string.

        Returns:
            TenantProfile: The resolved tenant profile configuration.
        """
        if not tenant_id or tenant_id not in self._tenants:
            return self._tenants["tenant-campabadal"]
        return self._tenants[tenant_id]


tenant_manager = TenantManager()
