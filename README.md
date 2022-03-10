# dockerscripts
The purpose of this project is to provide a set of containers on which the asterisk test suite can be built and run.

There are 2 Dockerfiles, one for CentOS7 and one for CentOS7 with python 3 installed (which is not currently supported.)

First step is to build an image from this file. Start by cd'ing to the CentOS7 directory and building an image with the following:

./buildImage CentOS7

The rest of the scripts rely on this testsuite/centos7 image first being created.  This will create you a base image that has a /usr/src/asterisk directory 
and all the pre-asterisk requirements.

The image relies on either a mount or a bind in order to build.  If you are running on Linux and want to test against an active directory that will have 
asterisk and the test suite supplied by the host operating system, then use the runCentos7_bindmount.sh (check the file for the mount structure):

./runCentos7_bindmount.sh <containername>

If your host OS is not Linux or you otherwise don't want to use a local folder, then use the runCentos7.sh script to 

./runCentos7.sh <containername> <asterisksourcemount> <outputmount>
  
This will start a container with name <containername> that uses the associated storage, but may or may not contain asterisk and testsuite sources depending 
on previous use.

If you are using a bindmount then chances are you will want to attach to the running container manually and go from there, but most of the existing scripts 
work in either method.

The simplest way to go from here is to use the buildOnContainer.sh script.  This works best with a mounted volume instead of a local bind as it will start 
by clearing out the asterisk and testsuite directories then clones the passed in release.  Example:
  
./buildOnContainer.sh <continername> <asteriskversion>
  
This would attach to the <containername> and clone asterisk and testsuite <asteriskversion> then run all pre-requisite, build both asterisk and the testsuite 
and then checks the available tests.
  
The helper script makeAsterisk.sh will clean and rebuild the existing asterisk without re-cloning.  reBuildOnContainer does the same as buildOnContainer but 
without deleting.  This is especially helpful if you just want to update an existing image or switch to a new git branch.

Lastly, testOnContainer.sh will run the runtests script on a running container for you, ie;

./testOnContainer.sh <containername> tests/realtime
   - or for all -
./testOnContainer.sh <containername> all
   - to list again - 
./testOnContainer.sh <containername> list
