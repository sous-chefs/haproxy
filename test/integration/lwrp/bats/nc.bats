setup() {
  rm -f /tmp/{one,two}
}


teardown(){
    pkill -9 nc
}



@test "can start netcat service" {
    LISTEN_PORT=5005
    SEND_PORT=5005
    FILE=/tmp/one
    MESSAGE=start
    nc -n -d -l 127.0.0.1 $LISTEN_PORT > $FILE & sleep 0.1
    echo $MESSAGE | nc  127.0.0.1 $SEND_PORT
    sleep 0.1
    grep $MESSAGE $FILE
}

@test "forwarding works" {
    LISTEN_PORT=5001
    LISTEN_PORT2=5002
    SEND_PORT=5000
    FILE=/tmp/one
    FILE2=/tmp/two
    MESSAGE=start
    nc -n -d -k -l 127.0.0.1 $LISTEN_PORT > $FILE & sleep 0.1
    nc -n -d -k -l 127.0.0.1 $LISTEN_PORT2 > $FILE2 & sleep 0.1
    echo $MESSAGE | nc  127.0.0.1 $SEND_PORT
    sleep 0.1
    echo $MESSAGE | nc  127.0.0.1 $SEND_PORT
    sleep 0.1
    grep $MESSAGE $FILE
    grep $MESSAGE $FILE2
}
