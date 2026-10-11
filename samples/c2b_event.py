"""Selected C2B event validation model; no provider transport or credentials."""
from decimal import Decimal
from pydantic import AliasChoices, BaseModel, Field

class C2BConfirmation(BaseModel):
    TransactionType: str
    TransID: str = Field(min_length=1, max_length=64)
    TransTime: str
    TransAmount: Decimal = Field(gt=0)
    BusinessShortCode: str
    BillRefNumber: str = Field(validation_alias=AliasChoices('BillRefNumber', 'BillRefNo'), min_length=1, max_length=64)
    MSISDN: str | None = None
    FirstName: str | None = None
    MiddleName: str | None = None
    LastName: str | None = None

