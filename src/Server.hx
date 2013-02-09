// Flash Sprite ? Maybe, remove
import flash.display.Sprite;
// RTMFP Connections
import flash.net.NetConnection;
import flash.net.GroupSpecifier;
import flash.net.NetGroup;
import flash.net.NetStream;
import flash.net.SharedObject;
import flash.events.NetStatusEvent;
// MongoDB CONNECTION
import tjson.TJSON;
import haxe.Http;

class Server extends Sprite
{
	// RTMFP SERVER DATA
	public static inline var CirrusCodeNameKey = "5bf8a9277e0ade52f43232c7-c68aa200d4bf";
	public static inline var CirrusConnService = "rtmfp://p2p.rtmfp.net/";
	// NET CONNECTION VARIABLES
	private var _nc:NetConnection;
	private var _netGroup:NetGroup;
	private var _netStreamSend:NetStream;
	private var _netStreamRecv:NetStream;
	private var _groupSpecifier:GroupSpecifier;
	private var _currentGroup:String;
	// UNIQUE SEQUENCE NUMBER FOR MESSAGES
	private var sequenceNumber:Int 	= 0;
	// GROUP CONNECTION VARIABLES
	private var connected:Bool 		= false;
	private var joinedGroup:Bool 	= false;
	// USER OBJECT
	public var User:Dynamic 		= null;

	/*
	 *	new NetConnection
	 * 	@userID:String
	 */
	public function new( userID:String )
	{
		super();
		User 	 = {};
		User._id = userID;
		createServerConnection();
		createDBConnection();
	}

	public function Server( userID:String )
	{
		new Server( userID );
	}
	/*
	 * 	DATABASE CONNECTION
	 */
	private function createDBConnection():Void
	{
		var url:String = "http://metioro.com/GolPlay/mongodb.php?collection=players&query=get&data="+User._id;
		flash.system.Security.allowDomain('*');
		var r:Http = new Http(url);
		r.onError = function( e ){
			trace('ERROR: ' + e);
		}
		r.onData = function( e:String ){
			var o:Dynamic = TJSON.parse(e);
			User._dbID = o[0].id;
			trace( "User._dbID: "+User._dbID );
		}
		r.request( false );
	}
	/*
	 *	SERVER CONNECTION
	 */
	private function createServerConnection():Void
	{
		trace( 'Connecting to RTMFP...');
		_nc = new NetConnection();
		_nc.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
		_nc.connect( CirrusConnService, CirrusCodeNameKey );
	}
	/*
	 *	SERVER DISCONNECTION
	 */
	private function createServerDisconnection( ):Void
	{
		if( _nc != null )
			_nc.close();
		connected = false;
	}
	/*
     *	GROUP CONNECTION
     */
	private function createGroupConnection( _nc:NetConnection, groupName:String ):Void
	{
		// CREATE GROUP FOR MATCH
		_groupSpecifier = new GroupSpecifier("world/"+groupName);
		_groupSpecifier.serverChannelEnabled = true;
		_groupSpecifier.postingEnabled = true;
		// NetGroup CONNECTION
		_netGroup = new NetGroup( _nc, _groupSpecifier.groupspecWithAuthorizations() );
		_netGroup.addEventListener( NetStatusEvent.NET_STATUS, netStatus );

		trace("Join \"" + _groupSpecifier.groupspecWithAuthorizations() + "\"\n");

		_currentGroup = groupName;
	}
    /*
     *	GROUP DISCONNECTION
     */
	private function createGroupDisconnection( ):Void
	{
		joinedGroup = false;
	}
	public function sendDataToGroup( text:String ):Void
	{
		var message:Dynamic = {};
		message.user = User.userID;
		message.text = text;
		message.sender = User.nearID;
		message.sequenceNumber = sequenceNumber++;
		_netGroup.post( message );
	}
	/*
     *	STREAM CONNECTION
     */
	public function createStreamConnection( _nc:NetConnection ):Void
	{
		if( connected ){
			_netStreamSend = new NetStream( _nc );
			_netStreamSend.addEventListener( NetStatusEvent.NET_STATUS, netStatus );
			var netStreamSendClient:Dynamic = {};
			_netStreamSend.client = netStreamSendClient;
			_netStreamSend.publish("partida", "live");

			_netStreamRecv = new NetStream( _nc );
			_netStreamRecv.addEventListener( NetStatusEvent.NET_STATUS, netStatus );
			_netStreamRecv.client = new Client();
			_netStreamRecv.play("partida");
		}else{
			throw "No connection to server";
		}
	}
	public function sendDataToStream( data:Dynamic ):Void
	{
		trace("Sending data to stream");
		_netStreamSend.send( "reciveDataFromStream", "Hola mundo...!" );
	}
	/*
     *	JOIN SPECIFIC ROOM
     */
	public function joinRoom( roomID:String, team:Int, number:Int):Void
	{
		if( connected ){
			// createStreamConnection( _nc );
			createGroupConnection( _nc, roomID );

			var url:String = "http://metioro.com/GolPlay/mongodb.php?collection=active_players&query=insert&data="+User._dbID+":"+roomID+":"+team+":"+number;
			flash.system.Security.allowDomain('*');
			var r:Http = new Http(url);
			r.onError = function( e ){
				trace('ERROR: ' + e);
			}
			r.onData = function( e:String ){
				User._oCon = e;
			}
			r.request( false );
		}else{
			throw "No connection to the server";
		}
	}
	public function quitRoom( roomID:String ):Void
	{
		var url:String = "http://metioro.com/GolPlay/mongodb.php?collection=active_players&query=delete&data="+User._dbID+":"+roomID;
		flash.system.Security.allowDomain('*');
		var r:Http = new Http(url);
		r.onError = function( e ){
			trace('ERROR: ' + e);
		}
		r.onData = function( e:String ){
			var o:Dynamic = TJSON.parse(e);
		}
		r.request( false );
	}
	public function postDataToGroup( data:Dynamic ):Void
	{
		var message  = data;
		message.User = User;
		message.sequenceNumber = sequenceNumber++;
		_netGroup.post( message );
	}
	public function shared( object:String ):Void
	{
		var myRemoteSO:SharedObject = flash.net.SharedObject.getRemote(_currentGroup+"/"+object, _nc.uri, false);
		myRemoteSO.connect( _nc );
		trace( "sharedObject called" );
	}
    /*
     *	NETSTATUS 
     */
    private function netStatus( event:NetStatusEvent ):Void
	{
		// trace(event.info.code);

		switch(event.info.code)
		{
			case "NetConnection.Connect.Success":
				onNetConnectionSuccess();
			case "NetConnection.Connect.Closed":
				onNetConnectionClosed();
			case "NetGroup.Connect.Success":
				onNetGroupSuccess();
			case "NetGroup.Posting.Notify":
				onNetGroupPostingNotify( event );
			case "NetGroup.Neighbor.Connect":
				onNetGroupNeighborConnect();
			case "NetGroup.Neighbor.Disconnect":
				onNetGroupNeighborDisconnect();
			case "NetStream.Connect.Success":
				trace( "NetStream Connect Success" );
			case "NetStream.Connected.Closed":
				trace( "NetStream Connect Closed" );
			case "NetStream.Publish.Start":
				trace( "NetStream Publish Start" );
			case "NetStream.Play.Start":
				trace( "NetStream started" );
    	}
    }
    /*
     *	NETSTATUS CALLBACKS
     */
    public function onNetConnectionSuccess()
    {
		trace("NetConnection Success");
		connected = true;
		User.nearID = _nc.nearID;
		trace("nearID: "+User.nearID);
    }
    public dynamic function onNetConnectionClosed()
    {
    	trace("NetConnection Closed");
    }
	public dynamic function onNetGroupSuccess()
	{
		trace("NetGroup Success");
	}
	public dynamic function onNetGroupNeighborConnect()
	{

	}
	public dynamic function onNetGroupNeighborDisconnect()
	{

	}
	public dynamic function onNetGroupPostingNotify( event:NetStatusEvent )
	{
		trace("NetGroup Posting Notify");
		trace(event.info.message + "\n");
 	}
}
class Client
{
	public function new()
	{

	}
	public function Client()
	{
		new Client();
	}
	public function onMetadata( data:Dynamic ):Void
	{
		trace("hi hola");
	}
	public function onTextData( data:Dynamic ):Void 
	{
		trace("Text: "+data);
	}
	public function onXMPData( data:Dynamic ):Void
	{
		trace("XMP: "+data);
	}
	public function onImageData( data:Dynamic ):Void
	{
		trace("image data");
	}
	public function reciveDataFromStream( data:Dynamic )
	{
		trace("Recive:: " + data);
	}
	public function print( text:String )
	{

	}
	public function moveBall(x, y:Float)
	{

	}
	public function movePlayer(x, y:Float)
	{

	}
}