module Integration

  class IntegrationError < StandardError
  end

  class BusinessRuleError < IntegrationError
  end

  class InvalidParameter < BusinessRuleError
  end

end