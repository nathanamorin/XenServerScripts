import os
import subproces
# inputStr = open("data.txt").read()

inputStr = subprocess.Popen('xe vm-list', stdout=subprocess.PIPE).stdout.read()
vms = []
for vmStr in inputStr.split('\n\n'):
		if vmStr == '\n':
				break
		vm = {}
		for vmStr in vmStr.split('\n'):
			pos = vmStr.find(': ')
			name = vmStr[:vmStr[:pos].find('(')].strip()
			if name == '':
				continue
			vm[ name ] = vmStr[pos+2:]


		vms.append(vm)

print "run commands generated or uncomment os.system calls to execute automatically"
print "\n\nrunning vms"
for vm in vms:
		if vm['power-state'] == 'running':
			cmd = "xe vm-param-set uuid="+vm['uuid']+" other-config:auto_poweron=true"
			print cmd
			#os.system(cmd)

print "\n\nhalted vms"
for vm in vms:
	if vm['power-state'] == 'halted':
		cmd = "xe vm-param-set uuid="+vm['uuid']+" other-config:auto_poweron=false"
		print cmd
		#os.system(cmd)








