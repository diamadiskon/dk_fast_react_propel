import { withAuthInfo } from '@propelauth/react';
import React from 'react';

// user is automatically injected from withAuthInfo
function UserInfo({ user }) {

    return (
        <div>
            <span>
                <h2>User Info</h2>
                {user && user.pictureUrl && <img src={user.pictureUrl} alt={"profile"} className="pictureUrl" />}
                <pre>user: {JSON.stringify(user, null, 2)}</pre>
            </span>
        </div>
    )
}

export default withAuthInfo(UserInfo);