import { withRequiredAuthInfo } from "@propelauth/react";
import React from 'react';
import { Link } from "react-router-dom";

function Home(props) {
    return (
        <div>
            <div className="home-style">
                <h1>Welcome to My Health</h1>
                <p>Explore the following options:</p>
                <div>
                    <Link to="/user_info">
                        Click here to see user info
                    </Link>
                </div>
                <div>
                    <Link to="/orgs">
                        Click here to see org info
                    </Link>
                </div>
                <div>
                    <Link to="/health">
                        Go to Health Dashboard
                    </Link>
                </div>
            </div>
        </div>
    );
}

export default withRequiredAuthInfo(Home);
