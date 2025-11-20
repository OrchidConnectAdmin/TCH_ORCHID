/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Registry {
    global Registry() {

    }
    global static List<Framework__Registry__mdt> getEntriesByCat(String category) {
        return null;
    }
    global static List<Framework__Registry__mdt> getEntriesByCat(String category, Boolean incudeDisabled) {
        return null;
    }
    global static List<Framework__Registry__mdt> getEntries() {
        return null;
    }
    global static List<Framework__Registry__mdt> getEntries(Boolean includeDisabled) {
        return null;
    }
    global static Framework__Registry__mdt getEntry(String category, String key) {
        return null;
    }
    global static Map<String,String> getEntryMapByCat(String category) {
        return null;
    }
    global static Map<String,String> getEntryMapByCat(String category, Boolean includeDisabled) {
        return null;
    }
    global static Boolean isEntryEnabled(String category, String key) {
        return null;
    }
    global static Boolean isEntryEnabled(String category, String key, String namespace) {
        return null;
    }
    global static Boolean runOnce(Framework.Scriptable s, String jobName) {
        return null;
    }
    global static void upsertEntries(List<Framework.Registry.Entry> entries) {

    }
    global static void upsertEntry(String category, String key, String value) {

    }
    global static void upsertEntry(String category, String key, String value, Boolean isEnabled) {

    }
    global static void upsertGenericEntries(List<Framework.Registry.GenericEntry> entries) {

    }
global class Entry {
    global String category;
    global String key;
    global String value;
    global Entry(String category, String key, String value) {

    }
}
global class GenericEntry {
    global Map<String,String> fqKeysValues;
    global String fullName;
    global String label;
    global GenericEntry(String fullName, String label, Map<String,Object> fqKeysObjValues) {

    }
    global GenericEntry(String fullName, String label, Map<String,String> fqKeysValues) {

    }
}
}
