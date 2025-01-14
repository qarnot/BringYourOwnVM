import qarnot

# Create the connection using the client token
conn = qarnot.connection.Connection(client_token="<<<TOKEN_HERE>>>")

# Create the task based on the profile 'bring-your-own-vm-network'
task = conn.create_task('byovm_poc', 'bring-your-own-vm-network')

# Retrieve or create a bucket based on its name
bucket = conn.retrieve_or_create_bucket('<<<BUCKET_NAME>>>')

# Sync the local directory with the bucket
bucket.sync_directory('<<<SOME_LOCAL_DIRECTORY>>>')

# Add the bucket as a resources provider for the task
task.resources.append(bucket)

# Add the bucket as an output directory (a different bucket can be chosen)
task.results = bucket

# The VM OS family
task.constants['VM_GUEST_OS_FAMILY'] = 'linux' # or 'windows'

# The command to execute inside the VM
task.constants['VM_CMD'] = '<<<COMMAND_HERE>>>'

# The command used to shutdown the VM
task.constants['VM_SHUTDOWN_CMD'] = '<<<COMMAND_HERE>>>'

# The username to ssh inside the VM
task.constants['VM_USER'] = '<<<VM_USER>>>'

# The password of the user to ssh inside the VM
task.constants['VM_PASSWORD'] = '<<<VM_PASSWORD>>>'

# The name of the VM inside the bucket
task.constants['VM_IMAGE_NAME'] = '<<<VM_NAME>>>'

task.submit()
