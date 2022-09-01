# frozen_string_literal: true

class ReplyComponent < ViewComponent::Base
    with_collection_parameter :reply
    def initialize(reply:, current_user:)
        @reply = reply
        @current_user = current_user
    end

    def creator_name
      @reply.user == @current_user ? "You" : @reply.user.name
    end
end
