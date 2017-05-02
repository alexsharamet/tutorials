# tutorials
# Qt
# overview
.user files should be deleted. It is local project configuration files

# about projects
# sample block
1. parent: 
	parent-child relation.
	signals and slots system.
1. qtThread:
	shows how to create thread.
	use exec() and stop thread.
	send signals and do it wrong(in same thread)
	send signals and do it right(timer and worker)
	dispose all alloced memory without parent/child relation.
# network block
1. client:
	use QTcpSocket to connect to host write/read data
1. server: (extremely naive version of server)
	create server(and listen)
	open new connection with socket
