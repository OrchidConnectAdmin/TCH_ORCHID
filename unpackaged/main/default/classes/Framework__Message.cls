/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Message {
    global static void addMessage(String message) {

    }
    global static void addMessage(Exception ex, Framework.Message.Severity severityType) {

    }
    global static void addMessage(String message, Framework.Message.Severity severityType) {

    }
    global static void addMessage(String messageStr, Framework.Message.Severity severityType, Boolean logMessage) {

    }
    global static void clear() {

    }
    global String getMessage() {
        return null;
    }
    global static List<Framework.Message> getMessages(Framework.Message.Severity severityType) {
        return null;
    }
    global static Map<Framework.Message.Severity,List<Framework.Message>> getMessages() {
        return null;
    }
    global Framework.Message.Severity getSeverity() {
        return null;
    }
    global static String serialize() {
        return null;
    }
global enum Severity {DANGER, ERROR, INFO, SUCCESS, WARNING}
}
