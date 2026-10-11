"""Selected tenant-onboarding schema from Nyumba Sole; no application configuration."""
from datetime import date
from decimal import Decimal
from pydantic import BaseModel, EmailStr, Field, field_validator
from uuid import UUID

class TenantCreate(BaseModel):
    unit_id: UUID; name: str = Field(min_length=2, max_length=120)
    phone_number: str = Field(pattern=r'^\+?[1-9][0-9]{7,14}$')
    email: EmailStr; contract_start_date: date; contract_end_date: date
    tenant_type: str = Field(default='INDIVIDUAL', pattern=r'^(INDIVIDUAL|BUSINESS)$')
    other_phone_number: str | None = Field(default=None, pattern=r'^\+?[1-9][0-9]{7,14}$')
    business_name: str | None = Field(default=None, max_length=120)
    business_type: str | None = Field(default=None, max_length=120)
    monthly_rent: Decimal | None = Field(default=None, gt=0)
    security_deposit: Decimal | None = Field(default=None, ge=0)
    first_billing_month: date | None = None
    @field_validator('contract_end_date')
    @classmethod
    def contract_end_after_start(cls, end: date, info):
        if (start := info.data.get('contract_start_date')) and end <= start: raise ValueError('must be after contract_start_date')
        return end

