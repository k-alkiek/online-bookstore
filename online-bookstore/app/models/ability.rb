class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
        can :read, Book
        can :create, User
    elsif user.isManager?
        can :manage, Author
        can :manage, Book
        can :manage, Order
        can :manage, Publisher
        can :read, Purchase
        can :checkout, Purchase
        can :confirm_checkout, Purchase
        can :manage, User
        can :manage, :report
        can :manage, :cart
    else
        can :read, Book
        can :read, Author
        can :read, Publisher
        can :read, Purchase, User_id: user.id
        can :checkout, Purchase
        can :confirm_checkout, Purchase
        can :update, User, id: user.id
        can :show, User, id: user.id
        can :manage, :cart
    end
  end
end
