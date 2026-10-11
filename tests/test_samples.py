from datetime import date
from decimal import Decimal
import pytest
from pydantic import ValidationError
from samples.tenancy_validation import TenantCreate
from samples.c2b_event import C2BConfirmation


def tenant(**overrides):
    values = dict(unit_id='00000000-0000-0000-0000-000000000201',
                  name='Demo Tenant', phone_number='+254000000000',
                  email='demo@example.com', contract_start_date=date(2026, 1, 1),
                  contract_end_date=date(2027, 1, 1), monthly_rent='20000.25',
                  security_deposit='20000')
    return TenantCreate(**(values | overrides))


def test_rent_and_deposit_are_distinct_exact_decimals():
    record = tenant()
    assert record.monthly_rent == Decimal('20000.25')
    assert record.security_deposit == Decimal('20000')


@pytest.mark.parametrize('end', [date(2026, 1, 1), date(2025, 12, 31)])
def test_lease_must_end_after_start(end):
    with pytest.raises(ValidationError): tenant(contract_end_date=end)


@pytest.mark.parametrize('overrides', [{'monthly_rent': '0'}, {'security_deposit': '-1'}])
def test_invalid_financial_terms_are_rejected(overrides):
    with pytest.raises(ValidationError): tenant(**overrides)


@pytest.mark.parametrize('reference_key', ['BillRefNo', 'BillRefNumber'])
def test_provider_reference_aliases(reference_key):
    event = C2BConfirmation(**dict(TransactionType='Pay Bill', TransID='DEMO-001',
        TransTime='20260101120000', TransAmount='10000.25',
        BusinessShortCode='DEMO', **{reference_key: 'DEMO-A01'}))
    assert event.BillRefNumber == 'DEMO-A01'
    assert event.TransAmount == Decimal('10000.25')


@pytest.mark.parametrize('amount', ['0', '-1'])
def test_nonpositive_received_payment_is_rejected(amount):
    with pytest.raises(ValidationError):
        C2BConfirmation(TransactionType='Pay Bill', TransID='DEMO-001',
            TransTime='20260101120000', TransAmount=amount,
            BusinessShortCode='DEMO', BillRefNo='DEMO-A01')
