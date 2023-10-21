import { withRequiredAuthInfo } from "@propelauth/react";
import React from 'react';
import { Link } from "react-router-dom";

const homeStyle = {
    textAlign: 'center',
    padding: '20px',
    backgroundColor: '#f0f0f0',
    borderRadius: '10px',
    boxShadow: '0 0 10px rgba(0, 0, 0, 0.2)',
    margin: '20px',
    color: 'red',
};

const linkStyle = {
    fontSize: '18px',
    textDecoration: 'none',
    color: 'blue',
    margin: '10px',
};

function Home(props) {
    return (
        <div style={homeStyle}>
            <h1>Welcome to My Health</h1>
            <p>Explore the following options:</p>
            <div>
                <Link to="/user_info" style={linkStyle}>
                    Click here to see user info
                </Link>
            </div>
            <div>
                <Link to="/orgs" style={linkStyle}>
                    Click here to see org info
                </Link>
            </div>
            <div>
                <Link to="/health" style={linkStyle}>
                    Go to Health Dashboard
                </Link>
            </div>
        </div>
    );
}

export default withRequiredAuthInfo(Home);
