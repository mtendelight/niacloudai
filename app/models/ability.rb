class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest

    # -------------------------
    # GUEST (not logged in)
    # -------------------------
    if user.new_record?
      can :create, User
      can :read, :all
      return
    end

    # -------------------------
    # ROOT (FULL CONTROL)
    # -------------------------
    if user.root?
      can :manage, :all
      can :access, :rails_admin
      can :destroy, :all
      return
    end

    # -------------------------
    # SUPERADMIN
    # -------------------------
    if user.superadmin?
      can :manage, :all
      can :access, :rails_admin
      return
    end

    # -------------------------
    # ADMIN
    # -------------------------
    if user.admin?
      can :manage, :all
      can :destroy, :all
      return
    end

    # -------------------------
    # MANAGER
    # -------------------------
    if user.manager?
      can :read, :all

      can :manage, Business
      can :manage, Block
      can :manage, Janomax
      can :manage, Niabnb
      can :manage, Buildingblock

      cannot :destroy, User
      cannot :destroy, Payment
      cannot :destroy, Invoice

      return
    end

    # -------------------------
    # CASHIER
    # -------------------------
    if user.cashier?
      can :read, :all

      cannot :manage, Payment
      cannot :manage, Invoice
      cannot :manage, Statement
      cannot :manage, Client

      return
    end

    # -------------------------
    # WAITER
    # -------------------------
    if user.waiter?
      can :read, :all

      can :create, Order
      can :update, Order

      cannot :destroy, Order

      return
    end

    # -------------------------
    # STAFF
    # -------------------------
    if user.staff?
      can :read, :all
      can :manage, Order
      can :manage, Customer

      return
    end

    # -------------------------
    # DEFAULT USER
    # -------------------------
    can :read, :all
  end
end