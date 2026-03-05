require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transaction = transactions(:one)
  end

  test "should get index" do
    get transactions_url, as: :json
    assert_response :success
  end

  test "should create transaction" do
    assert_difference("Transaction.count") do
      post transactions_url, params: { transaction: { balance: @transaction.balance, cash_balance: @transaction.cash_balance, cashless_balance: @transaction.cashless_balance, is_dispensed: @transaction.is_dispensed, item: @transaction.item, item_price: @transaction.item_price, serial_number: @transaction.serial_number } }, as: :json
    end

    assert_response :created
  end

  test "should show transaction" do
    get transaction_url(@transaction), as: :json
    assert_response :success
  end

  test "should update transaction" do
    patch transaction_url(@transaction), params: { transaction: { balance: @transaction.balance, cash_balance: @transaction.cash_balance, cashless_balance: @transaction.cashless_balance, is_dispensed: @transaction.is_dispensed, item: @transaction.item, item_price: @transaction.item_price, serial_number: @transaction.serial_number } }, as: :json
    assert_response :success
  end

  test "should destroy transaction" do
    assert_difference("Transaction.count", -1) do
      delete transaction_url(@transaction), as: :json
    end

    assert_response :no_content
  end
end
