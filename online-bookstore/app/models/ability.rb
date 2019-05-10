class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
        can :read, Book
    elsif user.isManager?
        can :manage, Author
        can :manage, Book
        can :manage, Order
        can :manage, Publisher
        can :read, Purchase
        can :manage, User
    else
        can :read, Book
        can :update, User, id: user.id
        can :show, User, id: user.id
        can :read, Purchase, User_id: user.id
    end
  end
end
