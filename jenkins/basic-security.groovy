import jenkins.model.*
import hudson.security.*
import jenkins.install.*;
import hudson.util.*;
def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)

hudsonRealm.createAccount("admin","Admin123")
instance.setSecurityRealm(hudsonRealm)
instance.save()

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)