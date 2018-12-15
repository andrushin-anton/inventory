class AccessPolicy
  include AccessGranted::Policy

  def configure
    # Example policy for AccessGranted.
    # For more details check the README at
    #
    # https://github.com/chaps-io/access-granted/blob/master/README.md
    #
    # Roles inherit from less important roles, so:
    # - :admin has permissions defined in :member, :guest and himself
    # - :member has permissions from :guest and himself
    # - :guest has only its own permissions since it's the first role.
    #
    # The most important role should be at the top.
    # In this case an administrator.
    #
    # role :admin, proc { |user| user.admin? } do
    #   can :destroy, User
    # end

    # More privileged role, applies to registered users.
    #
    # role :member, proc { |user| user.registered? } do
    #   can :create, Post
    #   can :create, Comment
    #   can [:update, :destroy], Post do |post, user|
    #     post.author == user
    #   end
    # end

    # The base role with no additional conditions.
    # Applies to every user.
    #
    # role :guest do
    #  can :read, Post
    #  can :read, Comment
    # end

    role :admin, proc { |user| user.role == 'admin' } do
      can [:index, :create, :new, :show, :edit, :update, :destroy, :update_password, :password, :activate, :staff, :staff_create, :staff_update, :staff_show, :staff_new, :staff_edit], User
      can [:index], Inventory
      can [:new, :create, :show, :update, :edit, :destroy], Item
      can [:index, :new, :create, :show, :update, :edit, :destroy], Order
    end

    role :user, proc { |user| user.role == 'user' } do
      can [:index, :show], Order
    end

  end
end
