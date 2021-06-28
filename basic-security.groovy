#!groovy

import jenkins.model.*
import jenkins.install.*;
import hudson.util.*;
import hudson.security.*;

def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)

#!create admin user
hudsonRealm.createAccount("admin","Admin123")
instance.setSecurityRealm(hudsonRealm)
instance.save()

#!disable setup wizard
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)