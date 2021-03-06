module SessionHelper
    def log_in(user)
        session[:user_id] = user.id
    end

    def logged_in?
        !current_user.nil?
    end

    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    # 退出当前用户
    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end

    # 在持久会话中记住用户
    def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def current_user
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
            # raise # test still pass, so test has not yet covered here
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end
end
