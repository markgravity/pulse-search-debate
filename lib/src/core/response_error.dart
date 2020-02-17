class ResponseError extends Error {
	final String message;
	ResponseError([this.message]);
	String toString() => "Response Error: $message";
}