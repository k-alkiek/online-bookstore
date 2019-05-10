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
        can :read, Author
        can :read, Publisher
        can :read, Purchase, User_id: user.id
        can :update, User, id: user.id
        can :show, User, id: user.id
    end
  end
end
