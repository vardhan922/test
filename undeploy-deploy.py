import sys
appname1=sys.argv[1]
apppath='/u01/app/oracle/newmiddleware/applications/'
def wlDeployUndeploy(username, password, adminURL, appName, location, targets, stageMode):
    try:
        #connect to admin server
        connect(username, password, adminURL)
        #start edit operation
        edit()
        startEdit()

        #stop application
        stopApplication(appName)

        #start undeploying application to "mycluster" server
        progress = undeploy(appName, timeout=60000)
        progress.printStatus()
        save()
        activate(20000,block="true")
        #start deploying application to ""mycluster" server
        progress = deploy(appName,location,targets)
        progress.printStatus()
        #print 'Done deploying application' +appname

    except Exception, e:
         print ex.toString()
wlDeployUndeploy('weblogic','weblogic1','t3://192.168.0.110:7001', appname1, apppath + appname1 + ".war", targets='mycluster', stageMode='stage')

