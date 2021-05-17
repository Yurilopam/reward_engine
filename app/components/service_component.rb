class ServiceComponent
  extend Dry::Container::Mixin

  register(:user_event_handlers, {
    UserAuthenticated: UserEventsHandlerComponent.resolve(:authenticated_event_handler),
    UserPaidBill: UserEventsHandlerComponent.resolve(:paid_bill_event_handler),
    UserMadeDepositIntoSavingsAccount: UserEventsHandlerComponent.resolve(:made_deposit_into_savings_account_event_handler)
  })

  register(:user_events_service, UserEventsService.new(self.resolve(:user_event_handlers)))
  register(:users_api_service, UsersApiService.new(User, Reward))
  register(:rewards_api_service, RewardsApiService.new(User, Reward))

end