---
title: Mass editing firewall on Rackspace Cloud.
author: chmouel
date: 2011-05-05T22:12:42+00:00
url: /2011/05/05/mass-editing-firewall-on-rackspace-cloud/
dsq_thread_id:
  - 296386800
tags:
  - Cloud
  - Rackspace

---
A lot of our customers in Rackspace cloud has been asking how to mass edit firewalls of servers when you have multiple servers without doing it manually.

Part of my [cloudservers-api-dem][1]o I have written a simple firewall scripts abstracting the Operating System firewall software to allow/enable/disable the firewall and ports/networks.

The script has been kept very simple by design and currently allow only to :

  * 
<span style="font-size: medium;"> 
    
    <p style="display: inline !important;">
      enable the firewall
    </p>
    
    <p>
      </span></li> 
      
      <li>
        <span style="font-size: medium;"> 
        
        <p style="display: inline !important;">
          disable the firewall
        </p>
        
        <p>
          </span></li> 
          
          <li>
            <span style="font-size: medium;"> 
            
            <p style="display: inline !important;">
              allow or disallow a port or a network
            </p>
            
            <p>
              </span></li> 
              
              <li>
                <span style="font-size: medium;"> 
                
                <p style="display: inline !important;">
                  see firewall status
                </p>
                
                <p>
                  </span></li> </ul> 
                  
                  <h3>
                    PREREQUISITES
                  </h3>
                  
                  <ul>
                    <li>
                      <span style="font-size: medium;"> 
                      
                      <p style="display: inline !important;">
                        A management server under Ubuntu maverick.
                      </p>
                      
                      <p>
                        </span></li> 
                        
                        <li>
                          <span style="font-size: medium;"> 
                          
                          <p style="display: inline !important;">
                            A supported Operating System for clients which includes :
                          </p>
                          
                          <p>
                            </span></li> 
                            
                            <li>
                              <span style="font-size: medium;"> 
                              
                              <p style="display: inline !important;">
                                Debian.
                              </p>
                              
                              <p>
                                </span></li> 
                                
                                <li>
                                  <span style="font-size: medium;"> 
                                  
                                  <p style="display: inline !important;">
                                    Ubuntu.
                                  </p>
                                  
                                  <p>
                                    </span></li> 
                                    
                                    <li>
                                      <span style="font-size: medium;"> 
                                      
                                      <p style="display: inline !important;">
                                        RHEL.
                                      </p>
                                      
                                      <p>
                                        </span></li> 
                                        
                                        <li>
                                          <span style="font-size: medium;"> 
                                          
                                          <p style="display: inline !important;">
                                            Fedora
                                          </p>
                                          
                                          <p>
                                            </span></li> 
                                            
                                            <li>
                                              <span style="font-size: medium;"> 
                                              
                                              <p style="display: inline !important;">
                                                My patched python-cloudservers library (see below for installs).
                                              </p>
                                              
                                              <p>
                                                </span></li> 
                                                
                                                <li>
                                                  <span style="font-size: medium;"> 
                                                  
                                                  <p style="display: inline !important;">
                                                    Your SSH key installed on all VM for root users.
                                                  </p>
                                                  
                                                  <p>
                                                    </span></li> </ul> 
                                                    
                                                    <h3>
                                                      Install
                                                    </h3>
                                                    
                                                    <ul>
                                                      <li>
                                                        <span style="font-size: medium;"> 
                                                        
                                                        <p style="display: inline !important;">
                                                          After you have kicked a VM with a Ubuntu maverick and connected to it as root you want first execute intall some prereq packages :
                                                        </p>
                                                        
                                                        <p>
                                                          </span></li> </ul> 
                                                          
                                                          <pre lang="sh">apt-get update && apt-get -y install python-stdeb git</pre>
                                                          
                                                          <p>
                                                            checkout my python-cloudservers library :
                                                          </p>
                                                          
                                                          <pre lang="sh">git clone git://github.com/chmouel/python-cloudservers.git</pre>
                                                          
                                                          <p>
                                                            after being checked-out you will go into the python-cloudservers directory which has just been created and do this :
                                                          </p>
                                                          
                                                          <pre lang="sh">cd python-cloudservers/
python setup.py install</pre>
                                                          
                                                          <p>
                                                            this should automatically install all the dependences.
                                                          </p>
                                                          
                                                          <p>
                                                            Now you can install my api-demo which include the firewall script :
                                                          </p>
                                                          
                                                          <pre lang="sh">cd ../
git clone git://github.com/chmouel/cloudservers-api-demo</pre>
                                                          
                                                          <p>
                                                            You need to configure some environemnt variable first which keep information about your rackspace account.
                                                          </p>
                                                          
                                                          <p>
                                                            edit your ~/.bashrc (or /etc/environement if you want to make it global) and configure those variable :
                                                          </p>
                                                          
                                                          <pre>export RCLOUD_DATACENTER=UK
export UK_RCLOUD_USER="MY_USERNAME"
export UK_RCLOUD_KEY="MY_API_KEY"
export UK_RCLOUD_AURL="https://lon.auth.api.rackspacecloud.com/v1.0"</pre>
                                                          
                                                          <p>
                                                            or for the US you would have :
                                                          </p>
                                                          
                                                          <pre>export RCLOUD_DATACENTER=US
export UK_RCLOUD_USER="MY_USERNAME"
export UK_RCLOUD_KEY="MY_API_KEY"
export UK_RCLOUD_AURL="https://auth.api.rackspacecloud.com/v1.0"</pre>
                                                          
                                                          <p>
                                                            source the ~/.bashrc or relog into your account to have those accounts set-up you can test it to see if that works by going to :
                                                          </p>
                                                          
                                                          <pre>~/cloudservers-api-demo/python</pre>
                                                          
                                                          <p>
                                                            and launch the command :
                                                          </p>
                                                          
                                                          <pre>./list-servers.py</pre>
                                                          
                                                          <p>
                                                            to test if this is working properly (it should list your servers for your DATACENTER)
                                                          </p>
                                                          
                                                          <p>
                                                            you are now basically ready to mass update firewall on all servers.
                                                          </p>
                                                          
                                                          <p>
                                                            Let's say you have two web servers named web1 and web2 and two db servers named db1 and db2 and you would like to allow the 80 port on the web servers and 3306 port on the db servers.
                                                          </p>
                                                          
                                                          <p>
                                                            You would have to go to this directory :
                                                          </p>
                                                          
                                                          <pre>~/cloudservers-api-demo/firewall/</pre>
                                                          
                                                          <p>
                                                            and first execute this command to see the help/usages :
                                                          </p>
                                                          
                                                          <pre>./fw-control.py --help</pre>
                                                          
                                                          <p>
                                                            so let's say to enable the firewall on all the web and db server first you can do :
                                                          </p>
                                                          
                                                          <pre>./fw-control.py -s "web db" enable</pre>
                                                          
                                                          <p>
                                                            it will connect and enable the firewall on all the servers which match the name web and db.
                                                          </p>
                                                          
                                                          <p>
                                                            now let's say we want to enable port 80 on the web :
                                                          </p>
                                                          
                                                          <pre>./fw-control.py -s "web" allow port 80</pre>
                                                          
                                                          <p>
                                                            if you log into the servers you can check with
                                                          </p>
                                                          
                                                          <pre>iptables -L -n</pre>
                                                          
                                                          <p>
                                                            that it it has been enabled properly.
                                                          </p>
                                                          
                                                          <p>
                                                            This is simple enough for you to modify the script to your liking to make it more modular for your specific environement.
                                                          </p>

 [1]: https://github.com/chmouel/cloudservers-api-demo