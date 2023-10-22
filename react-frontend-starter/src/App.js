import { useLogoutFunction, useRedirectFunctions, withAuthInfo } from '@propelauth/react';
import React from 'react';
import { Route, Routes } from "react-router-dom";
import './App.css';
import AuthenticatedRequest from './components/AuthenticatedRequest';
import HealthMetrics from './components/HealthMetrics';
import Home from './components/Home';
import ListOfOrgs from './components/ListOfOrgs';
import OrgInfo from './components/OrgInfo';
import UserInfo from './components/UserInfo';
import Navigation from './components/Navigation';


const App = withAuthInfo(({ isLoggedIn }) => {
    const logoutFn = useLogoutFunction()
    const { redirectToSignupPage, redirectToLoginPage } = useRedirectFunctions();

    if (isLoggedIn) {
        return <div>
            <Navigation />
            {/* <p>The User is logged in</p>
            <button onClick={() => logoutFn(true)}>
                Click here to log out
            </button> */}
            <Routes>
                <Route exact path="/" element={<Home />} />
                <Route exact path="/health" element={<HealthMetrics />} />
                <Route path="/user_info" element={<UserInfo />} />
                <Route path="/orgs" element={<ListOfOrgs />} />
                <Route path="/org/:orgName" element={<OrgInfo />} />
                <Route path="/auth" element={<AuthenticatedRequest />} />
            </Routes>
        </div>
    } else {
        return <div>
            To get started, please log in as test user.
            <br />
            <button onClick={() => redirectToSignupPage()}>
                Sign up
            </button>
            <button onClick={() => redirectToLoginPage()}>
                Log in
            </button>
        </div>
    } 
})

export default App;
