/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MetadataService {
    global MetadataService() {

    }
global class AccessMapping {
    global String accessLevel;
    global String object_x;
    global String objectField;
    global String userField;
    global AccessMapping() {

    }
}
global class AccountSettings extends Framework.MetadataService.Metadata {
    global Boolean enableAccountOwnerReport;
    global Boolean enableAccountTeams;
    global String fullName;
    global Boolean showViewHierarchyLink;
    global String type;
    global AccountSettings() {

    }
}
global class AccountSharingRuleSettings {
    global String caseAccessLevel;
    global String contactAccessLevel;
    global String opportunityAccessLevel;
    global AccountSharingRuleSettings() {

    }
}
global class ActionLinkGroupTemplate extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.ActionLinkTemplate> actionLinkTemplates;
    global String category;
    global String executionsAllowed;
    global String fullName;
    global Integer hoursUntilExpiration;
    global Boolean isPublished;
    global String name;
    global String type;
    global ActionLinkGroupTemplate() {

    }
}
global class ActionLinkTemplate {
    global String actionUrl;
    global String headers;
    global Boolean isConfirmationRequired;
    global Boolean isGroupDefault;
    global String labelKey;
    global String linkType;
    global String method;
    global Integer position;
    global String requestBody;
    global String userAlias;
    global String userVisibility;
    global ActionLinkTemplate() {

    }
}
global class ActionOverride {
    global String actionName;
    global String comment;
    global String content;
    global Boolean skipRecordTypeSelect;
    global String type_x;
    global ActionOverride() {

    }
}
global class ActivitiesSettings extends Framework.MetadataService.Metadata {
    global Boolean allowUsersToRelateMultipleContactsToTasksAndEvents;
    global Boolean enableActivityReminders;
    global Boolean enableClickCreateEvents;
    global Boolean enableDragAndDropScheduling;
    global Boolean enableEmailTracking;
    global Boolean enableEventScheduler;
    global Boolean enableGroupTasks;
    global Boolean enableListViewScheduling;
    global Boolean enableLogNote;
    global Boolean enableMultidayEvents;
    global Boolean enableRecurringEvents;
    global Boolean enableRecurringTasks;
    global Boolean enableSidebarCalendarShortcut;
    global Boolean enableSimpleTaskCreateUI;
    global Boolean enableUNSTaskDelegatedToNotifications;
    global String fullName;
    global String meetingRequestsLogo;
    global Boolean showCustomLogoMeetingRequests;
    global Boolean showEventDetailsMultiUserCalendar;
    global Boolean showHomePageHoverLinksForEvents;
    global Boolean showMyTasksHoverLinks;
    global Boolean showRequestedMeetingsOnHomePage;
    global String type;
    global ActivitiesSettings() {

    }
}
global class AddressSettings extends Framework.MetadataService.Metadata {
    global Framework.MetadataService.CountriesAndStates countriesAndStates;
    global String fullName;
    global String type;
    global AddressSettings() {

    }
}
global class AdjustmentsSettings {
    global Boolean enableAdjustments;
    global AdjustmentsSettings() {

    }
}
global class AgentConfigAssignments {
    global Framework.MetadataService.AgentConfigProfileAssignments profiles;
    global Framework.MetadataService.AgentConfigUserAssignments users;
    global AgentConfigAssignments() {

    }
}
global class AgentConfigButtons {
    global List<String> button;
    global AgentConfigButtons() {

    }
}
global class AgentConfigProfileAssignments {
    global List<String> profile;
    global AgentConfigProfileAssignments() {

    }
}
global class AgentConfigSkills {
    global List<String> skill;
    global AgentConfigSkills() {

    }
}
global class AgentConfigUserAssignments {
    global List<String> user_x;
    global AgentConfigUserAssignments() {

    }
}
global class AnalyticSnapshot extends Framework.MetadataService.Metadata {
    global String description;
    global String fullName;
    global String groupColumn;
    global List<Framework.MetadataService.AnalyticSnapshotMapping> mappings;
    global String name;
    global String runningUser;
    global String sourceReport;
    global String targetObject;
    global String type;
    global AnalyticSnapshot() {

    }
}
global class AnalyticSnapshotMapping {
    global String aggregateType;
    global String sourceField;
    global String sourceType;
    global String targetField;
    global AnalyticSnapshotMapping() {

    }
}
global class ApexClass extends Framework.MetadataService.MetadataWithContent {
    global Double apiVersion;
    global String content;
    global String fullName;
    global List<Framework.MetadataService.PackageVersion> packageVersions;
    global String status;
    global String type;
    global ApexClass() {

    }
}
global class ApexComponent extends Framework.MetadataService.MetadataWithContent {
    global Double apiVersion;
    global String content;
    global String description;
    global String fullName;
    global String label;
    global List<Framework.MetadataService.PackageVersion> packageVersions;
    global String type;
    global ApexComponent() {

    }
}
global class ApexPage extends Framework.MetadataService.MetadataWithContent {
    global Double apiVersion;
    global Boolean availableInTouch;
    global Boolean confirmationTokenRequired;
    global String content;
    global String description;
    global String fullName;
    global String label;
    global List<Framework.MetadataService.PackageVersion> packageVersions;
    global String type;
    global ApexPage() {

    }
}
global class ApexTrigger extends Framework.MetadataService.MetadataWithContent {
    global Double apiVersion;
    global String content;
    global String fullName;
    global List<Framework.MetadataService.PackageVersion> packageVersions;
    global String status;
    global String type;
    global ApexTrigger() {

    }
}
global class AppMenu extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.AppMenuItem> appMenuItems;
    global String fullName;
    global String type;
    global AppMenu() {

    }
}
global class AppMenuItem {
    global String name;
    global String type_x;
    global AppMenuItem() {

    }
}
global class ApprovalAction {
    global List<Framework.MetadataService.WorkflowActionReference> action;
    global ApprovalAction() {

    }
}
global class ApprovalEntryCriteria {
    global String booleanFilter;
    global List<Framework.MetadataService.FilterItem> criteriaItems;
    global String formula;
    global ApprovalEntryCriteria() {

    }
}
global class ApprovalPageField {
    global List<String> field;
    global ApprovalPageField() {

    }
}
global class ApprovalProcess extends Framework.MetadataService.Metadata {
    global Boolean active;
    global List<Framework.MetadataService.ApprovalSubmitter> allowedSubmitters;
    global Boolean allowRecall;
    global Framework.MetadataService.ApprovalPageField approvalPageFields;
    global List<Framework.MetadataService.ApprovalStep> approvalStep;
    global String description;
    global String emailTemplate;
    global Boolean enableMobileDeviceAccess;
    global Framework.MetadataService.ApprovalEntryCriteria entryCriteria;
    global Framework.MetadataService.ApprovalAction finalApprovalActions;
    global Boolean finalApprovalRecordLock;
    global Framework.MetadataService.ApprovalAction finalRejectionActions;
    global Boolean finalRejectionRecordLock;
    global String fullName;
    global Framework.MetadataService.ApprovalAction initialSubmissionActions;
    global String label;
    global Framework.MetadataService.NextAutomatedApprover nextAutomatedApprover;
    global String postTemplate;
    global Framework.MetadataService.ApprovalAction recallActions;
    global String recordEditability;
    global Boolean showApprovalHistory;
    global String type;
    global ApprovalProcess() {

    }
}
global class ApprovalStep {
    global Boolean allowDelegate;
    global Framework.MetadataService.ApprovalAction approvalActions;
    global Framework.MetadataService.ApprovalStepApprover assignedApprover;
    global String description;
    global Framework.MetadataService.ApprovalEntryCriteria entryCriteria;
    global String ifCriteriaNotMet;
    global String label;
    global String name;
    global Framework.MetadataService.ApprovalStepRejectBehavior rejectBehavior;
    global Framework.MetadataService.ApprovalAction rejectionActions;
    global ApprovalStep() {

    }
}
global class ApprovalStepApprover {
    global List<Framework.MetadataService.Approver> approver;
    global String whenMultipleApprovers;
    global ApprovalStepApprover() {

    }
}
global class ApprovalStepRejectBehavior {
    global String type_x;
    global ApprovalStepRejectBehavior() {

    }
}
global class ApprovalSubmitter {
    global String submitter;
    global String type_x;
    global ApprovalSubmitter() {

    }
}
global class Approver {
    global String name;
    global String type_x;
    global Approver() {

    }
}
global class ArticleTypeChannelDisplay {
    global List<Framework.MetadataService.ArticleTypeTemplate> articleTypeTemplates;
    global ArticleTypeChannelDisplay() {

    }
}
global class ArticleTypeTemplate {
    global String channel;
    global String page_x;
    global String template;
    global ArticleTypeTemplate() {

    }
}
global class AssignmentRule extends Framework.MetadataService.Metadata {
    global Boolean active;
    global String fullName;
    global List<Framework.MetadataService.RuleEntry> ruleEntry;
    global String type;
    global AssignmentRule() {

    }
}
global class AssignmentRules extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.AssignmentRule> assignmentRule;
    global String fullName;
    global String type;
    global AssignmentRules() {

    }
}
global class AsyncResult {
    global Boolean done;
    global String id;
    global String message;
    global String state;
    global String statusCode;
    global AsyncResult() {

    }
}
global class Attachment {
    global String content;
    global String name;
    global Attachment() {

    }
}
global class AuraDefinitionBundle extends Framework.MetadataService.Metadata {
    global String controllerContent;
    global String designContent;
    global String documentationContent;
    global String fullName;
    global String helperContent;
    global String markup;
    global String modelContent;
    global String rendererContent;
    global String styleContent;
    global String SVGContent;
    global String testsuiteContent;
    global String type;
    global String type_x;
    global AuraDefinitionBundle() {

    }
}
global class AuthProvider extends Framework.MetadataService.Metadata {
    global String authorizeUrl;
    global String consumerKey;
    global String consumerSecret;
    global String defaultScopes;
    global String errorUrl;
    global String executionUser;
    global String friendlyName;
    global String fullName;
    global String iconUrl;
    global String idTokenIssuer;
    global Boolean includeOrgIdInIdentifier;
    global String logoutUrl;
    global String portal;
    global String providerType;
    global String registrationHandler;
    global Boolean sendAccessTokenInHeader;
    global Boolean sendClientCredentialsInHeader;
    global String tokenUrl;
    global String type;
    global String userInfoUrl;
    global AuthProvider() {

    }
}
global class AutoResponseRule extends Framework.MetadataService.Metadata {
    global Boolean active;
    global String fullName;
    global List<Framework.MetadataService.RuleEntry> ruleEntry;
    global String type;
    global AutoResponseRule() {

    }
}
global class AutoResponseRules extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.AutoResponseRule> autoResponseRule;
    global String fullName;
    global String type;
    global AutoResponseRules() {

    }
}
global class Branding {
    global String loginFooterText;
    global String loginLogo;
    global String pageFooter;
    global String pageHeader;
    global String primaryColor;
    global String primaryComplementColor;
    global String quaternaryColor;
    global String quaternaryComplementColor;
    global String secondaryColor;
    global String tertiaryColor;
    global String tertiaryComplementColor;
    global String zeronaryColor;
    global String zeronaryComplementColor;
    global Branding() {

    }
}
global class BusinessHoursEntry extends Framework.MetadataService.Metadata {
    global Boolean active;
    global Boolean default_x;
    global Datetime fridayEndTime;
    global Datetime fridayStartTime;
    global String fullName;
    global Datetime mondayEndTime;
    global Datetime mondayStartTime;
    global String name;
    global Datetime saturdayEndTime;
    global Datetime saturdayStartTime;
    global Datetime sundayEndTime;
    global Datetime sundayStartTime;
    global Datetime thursdayEndTime;
    global Datetime thursdayStartTime;
    global String timeZoneId;
    global Datetime tuesdayEndTime;
    global Datetime tuesdayStartTime;
    global String type;
    global Datetime wednesdayEndTime;
    global Datetime wednesdayStartTime;
    global BusinessHoursEntry() {

    }
}
global class BusinessHoursSettings extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.BusinessHoursEntry> businessHours;
    global String fullName;
    global List<Framework.MetadataService.Holiday> holidays;
    global String type;
    global BusinessHoursSettings() {

    }
}
global class BusinessProcess extends Framework.MetadataService.Metadata {
    global String description;
    global String fullName;
    global Boolean isActive;
    global String type;
    global List<Framework.MetadataService.PicklistValue> values;
    global BusinessProcess() {

    }
}
global class CallCenter extends Framework.MetadataService.Metadata {
    global String adapterUrl;
    global String customSettings;
    global String displayName;
    global String displayNameLabel;
    global String fullName;
    global String internalNameLabel;
    global List<Framework.MetadataService.CallCenterSection> sections;
    global String type;
    global String version;
    global CallCenter() {

    }
}
global class CallCenterItem {
    global String label;
    global String name;
    global String value;
    global CallCenterItem() {

    }
}
global class CallCenterSection {
    global List<Framework.MetadataService.CallCenterItem> items;
    global String label;
    global String name;
    global CallCenterSection() {

    }
}
global class CallOptions_element {
    global String client;
    global CallOptions_element() {

    }
}
global class CancelDeployResult {
    global Boolean done;
    global String id;
    global CancelDeployResult() {

    }
}
global class CaseSettings extends Framework.MetadataService.Metadata {
    global String caseAssignNotificationTemplate;
    global String caseCloseNotificationTemplate;
    global String caseCommentNotificationTemplate;
    global String caseCreateNotificationTemplate;
    global List<Framework.MetadataService.FeedItemSettings> caseFeedItemSettings;
    global Boolean closeCaseThroughStatusChange;
    global String defaultCaseOwner;
    global String defaultCaseOwnerType;
    global String defaultCaseUser;
    global String emailActionDefaultsHandlerClass;
    global Framework.MetadataService.EmailToCaseSettings emailToCase;
    global Boolean enableCaseFeed;
    global Boolean enableDraftEmails;
    global Boolean enableEarlyEscalationRuleTriggers;
    global Boolean enableEmailActionDefaultsHandler;
    global Boolean enableSuggestedArticlesApplication;
    global Boolean enableSuggestedArticlesCustomerPortal;
    global Boolean enableSuggestedArticlesPartnerPortal;
    global Boolean enableSuggestedSolutions;
    global String fullName;
    global Boolean keepRecordTypeOnAssignmentRule;
    global Boolean notifyContactOnCaseComment;
    global Boolean notifyDefaultCaseOwner;
    global Boolean notifyOwnerOnCaseComment;
    global Boolean notifyOwnerOnCaseOwnerChange;
    global Boolean showFewerCloseActions;
    global String type;
    global Boolean useSystemEmailAddress;
    global Framework.MetadataService.WebToCaseSettings webToCase;
    global CaseSettings() {

    }
}
global class ChannelLayout {
    global List<String> enabledChannels;
    global String label;
    global List<Framework.MetadataService.ChannelLayoutItem> layoutItems;
    global ChannelLayout() {

    }
}
global class ChannelLayoutItem {
    global String field;
    global ChannelLayoutItem() {

    }
}
global class ChartSummary {
    global String aggregate;
    global String axisBinding;
    global String column;
    global ChartSummary() {

    }
}
global class ChatterAnswersReputationLevel {
    global String name;
    global Integer value;
    global ChatterAnswersReputationLevel() {

    }
}
global class ChatterAnswersSettings extends Framework.MetadataService.Metadata {
    global Boolean emailFollowersOnBestAnswer;
    global Boolean emailFollowersOnReply;
    global Boolean emailOwnerOnPrivateReply;
    global Boolean emailOwnerOnReply;
    global Boolean enableAnswerViaEmail;
    global Boolean enableChatterAnswers;
    global Boolean enableFacebookSSO;
    global Boolean enableInlinePublisher;
    global Boolean enableReputation;
    global Boolean enableRichTextEditor;
    global String facebookAuthProvider;
    global String fullName;
    global Boolean showInPortals;
    global String type;
    global ChatterAnswersSettings() {

    }
}
global class ChatterMobileSettings {
    global Boolean enablePushNotifications;
    global ChatterMobileSettings() {

    }
}
global class CodeCoverageResult {
    global List<Framework.MetadataService.CodeLocation> dmlInfo;
    global String id;
    global List<Framework.MetadataService.CodeLocation> locationsNotCovered;
    global List<Framework.MetadataService.CodeLocation> methodInfo;
    global String name;
    global String namespace;
    global Integer numLocations;
    global Integer numLocationsNotCovered;
    global List<Framework.MetadataService.CodeLocation> soqlInfo;
    global List<Framework.MetadataService.CodeLocation> soslInfo;
    global String type_x;
    global CodeCoverageResult() {

    }
}
global class CodeCoverageWarning {
    global String id;
    global String message;
    global String name;
    global String namespace;
    global CodeCoverageWarning() {

    }
}
global class CodeLocation {
    global Integer column;
    global Integer line;
    global Integer numExecutions;
    global Double time_x;
    global CodeLocation() {

    }
}
global class Community extends Framework.MetadataService.Metadata {
    global Boolean active;
    global String communityFeedPage;
    global String description;
    global String emailFooterDocument;
    global String emailHeaderDocument;
    global String emailNotificationUrl;
    global Boolean enableChatterAnswers;
    global Boolean enablePrivateQuestions;
    global String expertsGroup;
    global String fullName;
    global String portal;
    global Framework.MetadataService.ReputationLevels reputationLevels;
    global Boolean showInPortal;
    global String site;
    global String type;
    global Community() {

    }
}
global class CompactLayout extends Framework.MetadataService.Metadata {
    global List<String> fields;
    global String fullName;
    global String label;
    global String type;
    global CompactLayout() {

    }
}
global class CompanySettings extends Framework.MetadataService.Metadata {
    global Framework.MetadataService.FiscalYearSettings fiscalYear;
    global String fullName;
    global String type;
    global CompanySettings() {

    }
}
global class ComponentInstance {
    global List<Framework.MetadataService.ComponentInstanceProperty> componentInstanceProperties;
    global String componentName;
    global ComponentInstance() {

    }
}
global class ComponentInstanceProperty {
    global String name;
    global String value;
    global ComponentInstanceProperty() {

    }
}
global class ConnectedApp extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.ConnectedAppAttribute> attributes;
    global Framework.MetadataService.ConnectedAppCanvasConfig canvasConfig;
    global String contactEmail;
    global String contactPhone;
    global String description;
    global String fullName;
    global String iconUrl;
    global String infoUrl;
    global List<Framework.MetadataService.ConnectedAppIpRange> ipRanges;
    global String label;
    global String logoUrl;
    global Framework.MetadataService.ConnectedAppMobileDetailConfig mobileAppConfig;
    global String mobileStartUrl;
    global Framework.MetadataService.ConnectedAppOauthConfig oauthConfig;
    global Framework.MetadataService.ConnectedAppSamlConfig samlConfig;
    global String startUrl;
    global String type;
    global ConnectedApp() {

    }
}
global class ConnectedAppAttribute {
    global String formula;
    global String key;
    global ConnectedAppAttribute() {

    }
}
global class ConnectedAppCanvasConfig {
    global String accessMethod;
    global String canvasUrl;
    global String lifecycleClass;
    global List<String> locations;
    global List<String> options;
    global String samlInitiationMethod;
    global ConnectedAppCanvasConfig() {

    }
}
global class ConnectedAppIpRange {
    global String description;
    global String end_x;
    global String start;
    global ConnectedAppIpRange() {

    }
}
global class ConnectedAppMobileDetailConfig {
    global String applicationBinaryFile;
    global String applicationBinaryFileName;
    global String applicationBundleIdentifier;
    global Integer applicationFileLength;
    global String applicationIconFile;
    global String applicationIconFileName;
    global String applicationInstallUrl;
    global String devicePlatform;
    global String deviceType;
    global String minimumOsVersion;
    global Boolean privateApp;
    global String version;
    global ConnectedAppMobileDetailConfig() {

    }
}
global class ConnectedAppOauthConfig {
    global String callbackUrl;
    global String certificate;
    global String consumerKey;
    global String consumerSecret;
    global List<String> scopes;
    global ConnectedAppOauthConfig() {

    }
}
global class ConnectedAppSamlConfig {
    global String acsUrl;
    global String certificate;
    global String encryptionCertificate;
    global String encryptionType;
    global String entityUrl;
    global String issuer;
    global String samlNameIdFormat;
    global String samlSubjectCustomAttr;
    global String samlSubjectType;
    global ConnectedAppSamlConfig() {

    }
}
global class Container {
    global Integer height;
    global Boolean isContainerAutoSizeEnabled;
    global String region;
    global List<Framework.MetadataService.SidebarComponent> sidebarComponents;
    global String style;
    global String unit;
    global Integer width;
    global Container() {

    }
}
global class ContractSettings extends Framework.MetadataService.Metadata {
    global Boolean autoCalculateEndDate;
    global String autoExpirationDelay;
    global String autoExpirationRecipient;
    global Boolean autoExpireContracts;
    global Boolean enableContractHistoryTracking;
    global String fullName;
    global Boolean notifyOwnersOnContractExpiration;
    global String type;
    global ContractSettings() {

    }
}
global class CorsWhitelistOrigin extends Framework.MetadataService.Metadata {
    global String fullName;
    global String type;
    global String urlPattern;
    global CorsWhitelistOrigin() {

    }
}
global class CountriesAndStates {
    global List<Framework.MetadataService.Country> countries;
    global CountriesAndStates() {

    }
}
global class Country {
    global Boolean active;
    global String integrationValue;
    global String isoCode;
    global String label;
    global Boolean orgDefault;
    global Boolean standard;
    global List<Framework.MetadataService.State> states;
    global Boolean visible;
    global Country() {

    }
}
global class CustomApplication extends Framework.MetadataService.Metadata {
    global Framework.MetadataService.CustomApplicationComponents customApplicationComponents;
    global String defaultLandingTab;
    global String description;
    global String detailPageRefreshMethod;
    global Framework.MetadataService.DomainWhitelist domainWhitelist;
    global Boolean enableKeyboardShortcuts;
    global Boolean enableMultiMonitorComponents;
    global String fullName;
    global Boolean isServiceCloudConsole;
    global Framework.MetadataService.KeyboardShortcuts keyboardShortcuts;
    global String label;
    global Framework.MetadataService.ListPlacement listPlacement;
    global String listRefreshMethod;
    global Framework.MetadataService.LiveAgentConfig liveAgentConfig;
    global String logo;
    global Framework.MetadataService.PushNotifications pushNotifications;
    global Boolean saveUserSessions;
    global List<String> tab;
    global String type;
    global Framework.MetadataService.WorkspaceMappings workspaceMappings;
    global CustomApplication() {

    }
}
global class CustomApplicationComponent extends Framework.MetadataService.Metadata {
    global String buttonIconUrl;
    global String buttonStyle;
    global String buttonText;
    global Integer buttonWidth;
    global String fullName;
    global Integer height;
    global Boolean isHeightFixed;
    global Boolean isHidden;
    global Boolean isWidthFixed;
    global String type;
    global String visualforcePage;
    global Integer width;
    global CustomApplicationComponent() {

    }
}
global class CustomApplicationComponents {
    global String alignment;
    global List<String> customApplicationComponent;
    global CustomApplicationComponents() {

    }
}
global class CustomApplicationTranslation {
    global String label;
    global String name;
    global CustomApplicationTranslation() {

    }
}
global class CustomConsoleComponents {
    global Framework.MetadataService.PrimaryTabComponents primaryTabComponents;
    global Framework.MetadataService.SubtabComponents subtabComponents;
    global CustomConsoleComponents() {

    }
}
global class CustomDataType extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.CustomDataTypeComponent> customDataTypeComponents;
    global String description;
    global String displayFormula;
    global Boolean editComponentsOnSeparateLines;
    global String fullName;
    global String label;
    global Boolean rightAligned;
    global Boolean supportComponentsInReports;
    global String type;
    global CustomDataType() {

    }
}
global class CustomDataTypeComponent {
    global String developerSuffix;
    global Boolean enforceFieldRequiredness;
    global String label;
    global Integer length;
    global Integer precision;
    global Integer scale;
    global String sortOrder;
    global Integer sortPriority;
    global String type_x;
    global CustomDataTypeComponent() {

    }
}
global class CustomDataTypeComponentTranslation {
    global String developerSuffix;
    global String label;
    global CustomDataTypeComponentTranslation() {

    }
}
global class CustomDataTypeTranslation {
    global List<Framework.MetadataService.CustomDataTypeComponentTranslation> components;
    global String customDataTypeName;
    global String description;
    global String label;
    global CustomDataTypeTranslation() {

    }
}
global class CustomField extends Framework.MetadataService.Metadata {
    global Boolean caseSensitive;
    global String customDataType;
    global String defaultValue;
    global String deleteConstraint;
    global Boolean deprecated;
    global String description;
    global String displayFormat;
    global Boolean escapeMarkup;
    global String externalDeveloperName;
    global Boolean externalId;
    global String formula;
    global String formulaTreatBlanksAs;
    global String fullName;
    global String inlineHelpText;
    global Boolean isFilteringDisabled;
    global Boolean isNameField;
    global Boolean isSortingDisabled;
    global String label;
    global Integer length;
    global Framework.MetadataService.LookupFilter lookupFilter;
    global String maskChar;
    global String maskType;
    global Framework.MetadataService.Picklist picklist;
    global Boolean populateExistingRows;
    global Integer precision;
    global String referenceTargetField;
    global String referenceTo;
    global String relationshipLabel;
    global String relationshipName;
    global Integer relationshipOrder;
    global Boolean reparentableMasterDetail;
    global Boolean required;
    global Boolean restrictedAdminField;
    global Integer scale;
    global Integer startingNumber;
    global Boolean stripMarkup;
    global String summarizedField;
    global List<Framework.MetadataService.FilterItem> summaryFilterItems;
    global String summaryForeignKey;
    global String summaryOperation;
    global Boolean trackFeedHistory;
    global Boolean trackHistory;
    global Boolean trackTrending;
    global String type;
    global String type_x;
    global Boolean unique;
    global Integer visibleLines;
    global Boolean writeRequiresMasterRead;
    global CustomField() {

    }
}
global class CustomFieldTranslation {
    global List<Framework.MetadataService.ObjectNameCaseValue> caseValues;
    global String gender;
    global String help;
    global String label;
    global Framework.MetadataService.LookupFilterTranslation lookupFilter;
    global String name;
    global List<Framework.MetadataService.PicklistValueTranslation> picklistValues;
    global String relationshipLabel;
    global String startsWith;
    global CustomFieldTranslation() {

    }
}
global class CustomLabel extends Framework.MetadataService.Metadata {
    global String categories;
    global String fullName;
    global String language;
    global Boolean protected_x;
    global String shortDescription;
    global String type;
    global String value;
    global CustomLabel() {

    }
}
global class CustomLabelTranslation {
    global String label;
    global String name;
    global CustomLabelTranslation() {

    }
}
global class CustomLabels extends Framework.MetadataService.Metadata {
    global String fullName;
    global List<Framework.MetadataService.CustomLabel> labels;
    global String type;
    global CustomLabels() {

    }
}
global class CustomMetadata extends Framework.MetadataService.Metadata {
    global String description;
    global String fullName;
    global String label;
    global String type;
    global List<Framework.MetadataService.CustomMetadataValue> values;
    global CustomMetadata() {

    }
}
global class CustomMetadataValue {
    global String field;
    global String value;
    global CustomMetadataValue() {

    }
}
global class CustomObject extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.ActionOverride> actionOverrides;
    global Framework.MetadataService.ArticleTypeChannelDisplay articleTypeChannelDisplay;
    global List<Framework.MetadataService.BusinessProcess> businessProcesses;
    global String compactLayoutAssignment;
    global List<Framework.MetadataService.CompactLayout> compactLayouts;
    global String customHelp;
    global String customHelpPage;
    global String customSettingsType;
    global String customSettingsVisibility;
    global String deploymentStatus;
    global Boolean deprecated;
    global String description;
    global Boolean enableActivities;
    global Boolean enableBulkApi;
    global Boolean enableDivisions;
    global Boolean enableEnhancedLookup;
    global Boolean enableFeeds;
    global Boolean enableHistory;
    global Boolean enableReports;
    global Boolean enableSharing;
    global Boolean enableStreamingApi;
    global String externalDataSource;
    global String externalName;
    global String externalRepository;
    global String externalSharingModel;
    global List<Framework.MetadataService.CustomField> fields;
    global List<Framework.MetadataService.FieldSet> fieldSets;
    global String fullName;
    global String gender;
    global Framework.MetadataService.HistoryRetentionPolicy historyRetentionPolicy;
    global Boolean household;
    global String label;
    global List<Framework.MetadataService.ListView> listViews;
    global Framework.MetadataService.CustomField nameField;
    global String pluralLabel;
    global List<Framework.MetadataService.RecordType> recordTypes;
    global Boolean recordTypeTrackFeedHistory;
    global Boolean recordTypeTrackHistory;
    global Framework.MetadataService.SearchLayouts searchLayouts;
    global String sharingModel;
    global List<Framework.MetadataService.SharingReason> sharingReasons;
    global List<Framework.MetadataService.SharingRecalculation> sharingRecalculations;
    global String startsWith;
    global String type;
    global List<Framework.MetadataService.ValidationRule> validationRules;
    global List<Framework.MetadataService.WebLink> webLinks;
    global CustomObject() {

    }
}
global class CustomObjectTranslation extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.ObjectNameCaseValue> caseValues;
    global List<Framework.MetadataService.CustomFieldTranslation> fields;
    global String fullName;
    global String gender;
    global List<Framework.MetadataService.LayoutTranslation> layouts;
    global String nameFieldLabel;
    global List<Framework.MetadataService.QuickActionTranslation> quickActions;
    global List<Framework.MetadataService.RecordTypeTranslation> recordTypes;
    global List<Framework.MetadataService.SharingReasonTranslation> sharingReasons;
    global List<Framework.MetadataService.StandardFieldTranslation> standardFields;
    global String startsWith;
    global String type;
    global List<Framework.MetadataService.ValidationRuleTranslation> validationRules;
    global List<Framework.MetadataService.WebLinkTranslation> webLinks;
    global List<Framework.MetadataService.WorkflowTaskTranslation> workflowTasks;
    global CustomObjectTranslation() {

    }
}
global class CustomPageWebLink extends Framework.MetadataService.Metadata {
    global String availability;
    global String description;
    global String displayType;
    global String encodingKey;
    global String fullName;
    global Boolean hasMenubar;
    global Boolean hasScrollbars;
    global Boolean hasToolbar;
    global Integer height;
    global Boolean isResizable;
    global String linkType;
    global String masterLabel;
    global String openType;
    global String page_x;
    global String position;
    global Boolean protected_x;
    global Boolean requireRowSelection;
    global String scontrol;
    global Boolean showsLocation;
    global Boolean showsStatus;
    global String type;
    global String url;
    global Integer width;
    global CustomPageWebLink() {

    }
}
global class CustomPageWebLinkTranslation {
    global String label;
    global String name;
    global CustomPageWebLinkTranslation() {

    }
}
global class CustomPermission extends Framework.MetadataService.Metadata {
    global String connectedApp;
    global String description;
    global String fullName;
    global String label;
    global List<Framework.MetadataService.CustomPermissionDependencyRequired> requiredPermission;
    global String type;
    global CustomPermission() {

    }
}
global class CustomPermissionDependencyRequired {
    global String customPermission;
    global Boolean dependency;
    global CustomPermissionDependencyRequired() {

    }
}
global class CustomShortcut {
    global String description;
    global String eventName;
    global CustomShortcut() {

    }
}
global class CustomSite extends Framework.MetadataService.Metadata {
    global Boolean active;
    global Boolean allowHomePage;
    global Boolean allowStandardAnswersPages;
    global Boolean allowStandardIdeasPages;
    global Boolean allowStandardLookups;
    global Boolean allowStandardSearch;
    global String analyticsTrackingCode;
    global String authorizationRequiredPage;
    global String bandwidthExceededPage;
    global String changePasswordPage;
    global String chatterAnswersForgotPasswordConfirmPage;
    global String chatterAnswersForgotPasswordPage;
    global String chatterAnswersHelpPage;
    global String chatterAnswersLoginPage;
    global String chatterAnswersRegistrationPage;
    global String clickjackProtectionLevel;
    global List<Framework.MetadataService.SiteWebAddress> customWebAddresses;
    global String description;
    global String favoriteIcon;
    global String fileNotFoundPage;
    global String fullName;
    global String genericErrorPage;
    global String guestProfile;
    global String inactiveIndexPage;
    global String indexPage;
    global String inMaintenancePage;
    global String masterLabel;
    global String myProfilePage;
    global String portal;
    global Boolean requireHttps;
    global Boolean requireInsecurePortalAccess;
    global String robotsTxtPage;
    global String rootComponent;
    global String selfRegPage;
    global String serverIsDown;
    global String siteAdmin;
    global List<Framework.MetadataService.SiteRedirectMapping> siteRedirectMappings;
    global String siteTemplate;
    global String siteType;
    global String subdomain;
    global String type;
    global String urlPathPrefix;
    global CustomSite() {

    }
}
global class CustomTab extends Framework.MetadataService.Metadata {
    global String auraComponent;
    global Boolean customObject;
    global String description;
    global String flexiPage;
    global Integer frameHeight;
    global String fullName;
    global Boolean hasSidebar;
    global String icon;
    global String label;
    global Boolean mobileReady;
    global String motif;
    global String page_x;
    global String scontrol;
    global String splashPageLink;
    global String type;
    global String url;
    global String urlEncodingKey;
    global CustomTab() {

    }
}
global class CustomTabTranslation {
    global String label;
    global String name;
    global CustomTabTranslation() {

    }
}
global class Dashboard extends Framework.MetadataService.Metadata {
    global String backgroundEndColor;
    global String backgroundFadeDirection;
    global String backgroundStartColor;
    global List<Framework.MetadataService.DashboardFilter> dashboardFilters;
    global String dashboardResultRefreshedDate;
    global String dashboardResultRunningUser;
    global String dashboardType;
    global String description;
    global String fullName;
    global Framework.MetadataService.DashboardComponentSection leftSection;
    global Framework.MetadataService.DashboardComponentSection middleSection;
    global Framework.MetadataService.DashboardComponentSection rightSection;
    global String runningUser;
    global String textColor;
    global String title;
    global String titleColor;
    global Integer titleSize;
    global String type;
    global Dashboard() {

    }
}
global class DashboardComponent {
    global Boolean autoselectColumnsFromReport;
    global String chartAxisRange;
    global Double chartAxisRangeMax;
    global Double chartAxisRangeMin;
    global List<Framework.MetadataService.ChartSummary> chartSummary;
    global String componentType;
    global List<Framework.MetadataService.DashboardFilterColumn> dashboardFilterColumns;
    global List<Framework.MetadataService.DashboardTableColumn> dashboardTableColumn;
    global String displayUnits;
    global String drillDownUrl;
    global Boolean drillEnabled;
    global Boolean drillToDetailEnabled;
    global Boolean enableHover;
    global Boolean expandOthers;
    global String footer;
    global Double gaugeMax;
    global Double gaugeMin;
    global List<String> groupingColumn;
    global String header;
    global Double indicatorBreakpoint1;
    global Double indicatorBreakpoint2;
    global String indicatorHighColor;
    global String indicatorLowColor;
    global String indicatorMiddleColor;
    global String legendPosition;
    global Integer maxValuesDisplayed;
    global String metricLabel;
    global String page_x;
    global Integer pageHeightInPixels;
    global String report;
    global String scontrol;
    global Integer scontrolHeightInPixels;
    global Boolean showPercentage;
    global Boolean showPicturesOnCharts;
    global Boolean showPicturesOnTables;
    global Boolean showTotal;
    global Boolean showValues;
    global String sortBy;
    global String title;
    global Boolean useReportChart;
    global DashboardComponent() {

    }
}
global class DashboardComponentSection {
    global String columnSize;
    global List<Framework.MetadataService.DashboardComponent> components;
    global DashboardComponentSection() {

    }
}
global class DashboardFilter {
    global List<Framework.MetadataService.DashboardFilterOption> dashboardFilterOptions;
    global String name;
    global DashboardFilter() {

    }
}
global class DashboardFilterColumn {
    global String column;
    global DashboardFilterColumn() {

    }
}
global class DashboardFilterOption {
    global String operator;
    global List<String> values;
    global DashboardFilterOption() {

    }
}
global class DashboardFolder extends Framework.MetadataService.Folder {
    global String accessType;
    global List<Framework.MetadataService.FolderShare> folderShares;
    global String fullName;
    global String name;
    global String publicFolderAccess;
    global Framework.MetadataService.SharedTo sharedTo;
    global String type;
    global DashboardFolder() {

    }
}
global class DashboardMobileSettings {
    global Boolean enableDashboardIPadApp;
    global DashboardMobileSettings() {

    }
}
global class DashboardTableColumn {
    global String aggregateType;
    global Boolean calculatePercent;
    global String column;
    global Integer decimalPlaces;
    global Boolean showTotal;
    global String sortBy;
    global DashboardTableColumn() {

    }
}
global class DataCategory {
    global List<Framework.MetadataService.DataCategory> dataCategory;
    global String label;
    global String name;
    global DataCategory() {

    }
}
global class DataCategoryGroup extends Framework.MetadataService.Metadata {
    global Boolean active;
    global Framework.MetadataService.DataCategory dataCategory;
    global String description;
    global String fullName;
    global String label;
    global Framework.MetadataService.ObjectUsage objectUsage;
    global String type;
    global DataCategoryGroup() {

    }
}
global class DataPipeline {
    global Double apiVersion;
    global String label;
    global String scriptType;
    global DataPipeline() {

    }
}
global class DebuggingHeader_element {
    global List<Framework.MetadataService.LogInfo> categories;
    global String debugLevel;
    global DebuggingHeader_element() {

    }
}
global class DebuggingInfo_element {
    global String debugLog;
    global DebuggingInfo_element() {

    }
}
global class DefaultShortcut {
    global String action;
    global Boolean active;
    global String keyCommand;
    global DefaultShortcut() {

    }
}
global class DeleteResult {
    global List<Framework.MetadataService.Error> errors;
    global String fullName;
    global Boolean success;
    global DeleteResult() {

    }
}
global class DeployDetails {
    global List<Framework.MetadataService.DeployMessage> componentFailures;
    global List<Framework.MetadataService.DeployMessage> componentSuccesses;
    global Framework.MetadataService.RetrieveResult retrieveResult;
    global Framework.MetadataService.RunTestsResult runTestResult;
    global DeployDetails() {

    }
}
global class DeployMessage {
    global Boolean changed;
    global Integer columnNumber;
    global String componentType;
    global Boolean created;
    global Datetime createdDate;
    global Boolean deleted;
    global String fileName;
    global String fullName;
    global String id;
    global Integer lineNumber;
    global String problem;
    global String problemType;
    global Boolean success;
    global DeployMessage() {

    }
}
global class DeployOptions {
    global Boolean allowMissingFiles;
    global Boolean autoUpdatePackage;
    global Boolean checkOnly;
    global Boolean ignoreWarnings;
    global Boolean performRetrieve;
    global Boolean purgeOnDelete;
    global Boolean rollbackOnError;
    global Boolean runAllTests;
    global List<String> runTests;
    global Boolean singlePackage;
    global DeployOptions() {

    }
}
global class DeployResult {
    global String canceledBy;
    global String canceledByName;
    global Boolean checkOnly;
    global Datetime completedDate;
    global String createdBy;
    global String createdByName;
    global Datetime createdDate;
    global Framework.MetadataService.DeployDetails details;
    global Boolean done;
    global String errorMessage;
    global String errorStatusCode;
    global String id;
    global Boolean ignoreWarnings;
    global Datetime lastModifiedDate;
    global Integer numberComponentErrors;
    global Integer numberComponentsDeployed;
    global Integer numberComponentsTotal;
    global Integer numberTestErrors;
    global Integer numberTestsCompleted;
    global Integer numberTestsTotal;
    global Boolean rollbackOnError;
    global Boolean runTestsEnabled;
    global Datetime startDate;
    global String stateDetail;
    global String status;
    global Boolean success;
    global DeployResult() {

    }
}
global class DescribeMetadataObject {
    global List<String> childXmlNames;
    global String directoryName;
    global Boolean inFolder;
    global Boolean metaFile;
    global String suffix;
    global String xmlName;
    global DescribeMetadataObject() {

    }
}
global class DescribeMetadataResult {
    global List<Framework.MetadataService.DescribeMetadataObject> metadataObjects;
    global String organizationNamespace;
    global Boolean partialSaveAllowed;
    global Boolean testRequired;
    global DescribeMetadataResult() {

    }
}
global class DescribeValueTypeResult {
    global List<Framework.MetadataService.ValueTypeField> valueTypeFields;
    global DescribeValueTypeResult() {

    }
}
global class Document extends Framework.MetadataService.MetadataWithContent {
    global String content;
    global String description;
    global String fullName;
    global Boolean internalUseOnly;
    global String keywords;
    global String name;
    global Boolean public_x;
    global String type;
    global Document() {

    }
}
global class DocumentFolder extends Framework.MetadataService.Folder {
    global String accessType;
    global List<Framework.MetadataService.FolderShare> folderShares;
    global String fullName;
    global String name;
    global String publicFolderAccess;
    global Framework.MetadataService.SharedTo sharedTo;
    global String type;
    global DocumentFolder() {

    }
}
global class DomainWhitelist {
    global List<String> domain;
    global DomainWhitelist() {

    }
}
global class EmailFolder extends Framework.MetadataService.Folder {
    global String accessType;
    global List<Framework.MetadataService.FolderShare> folderShares;
    global String fullName;
    global String name;
    global String publicFolderAccess;
    global Framework.MetadataService.SharedTo sharedTo;
    global String type;
    global EmailFolder() {

    }
}
global class EmailTemplate extends Framework.MetadataService.MetadataWithContent {
    global Double apiVersion;
    global List<String> attachedDocuments;
    global List<Framework.MetadataService.Attachment> attachments;
    global Boolean available;
    global String content;
    global String description;
    global String encodingKey;
    global String fullName;
    global String letterhead;
    global String name;
    global List<Framework.MetadataService.PackageVersion> packageVersions;
    global String style;
    global String subject;
    global String textOnly;
    global String type;
    global String type_x;
    global EmailTemplate() {

    }
}
global class EmailToCaseRoutingAddress {
    global String addressType;
    global String authorizedSenders;
    global String caseOrigin;
    global String caseOwner;
    global String caseOwnerType;
    global String casePriority;
    global Boolean createTask;
    global String emailAddress;
    global String routingName;
    global Boolean saveEmailHeaders;
    global String taskStatus;
    global EmailToCaseRoutingAddress() {

    }
}
global class EmailToCaseSettings {
    global Boolean enableEmailToCase;
    global Boolean enableHtmlEmail;
    global Boolean enableOnDemandEmailToCase;
    global Boolean enableThreadIDInBody;
    global Boolean enableThreadIDInSubject;
    global Boolean notifyOwnerOnNewCaseEmail;
    global String overEmailLimitAction;
    global List<Framework.MetadataService.EmailToCaseRoutingAddress> routingAddresses;
    global String unauthorizedSenderAction;
    global EmailToCaseSettings() {

    }
}
global class EntitlementProcess extends Framework.MetadataService.Metadata {
    global Boolean active;
    global String businessHours;
    global String description;
    global String entryStartDateField;
    global String exitCriteriaBooleanFilter;
    global List<Framework.MetadataService.FilterItem> exitCriteriaFilterItems;
    global String exitCriteriaFormula;
    global String fullName;
    global Boolean isVersionDefault;
    global List<Framework.MetadataService.EntitlementProcessMilestoneItem> milestones;
    global String name;
    global String type;
    global String versionMaster;
    global String versionNotes;
    global Integer versionNumber;
    global EntitlementProcess() {

    }
}
global class EntitlementProcessMilestoneItem {
    global String businessHours;
    global String criteriaBooleanFilter;
    global List<Framework.MetadataService.FilterItem> milestoneCriteriaFilterItems;
    global String milestoneCriteriaFormula;
    global String milestoneName;
    global String minutesCustomClass;
    global Integer minutesToComplete;
    global List<Framework.MetadataService.WorkflowActionReference> successActions;
    global List<Framework.MetadataService.EntitlementProcessMilestoneTimeTrigger> timeTriggers;
    global Boolean useCriteriaStartTime;
    global EntitlementProcessMilestoneItem() {

    }
}
global class EntitlementProcessMilestoneTimeTrigger {
    global List<Framework.MetadataService.WorkflowActionReference> actions;
    global Integer timeLength;
    global String workflowTimeTriggerUnit;
    global EntitlementProcessMilestoneTimeTrigger() {

    }
}
global class EntitlementSettings extends Framework.MetadataService.Metadata {
    global Boolean assetLookupLimitedToActiveEntitlementsOnAccount;
    global Boolean assetLookupLimitedToActiveEntitlementsOnContact;
    global Boolean assetLookupLimitedToSameAccount;
    global Boolean assetLookupLimitedToSameContact;
    global Boolean enableEntitlements;
    global Boolean enableEntitlementVersioning;
    global Boolean entitlementLookupLimitedToActiveStatus;
    global Boolean entitlementLookupLimitedToSameAccount;
    global Boolean entitlementLookupLimitedToSameAsset;
    global Boolean entitlementLookupLimitedToSameContact;
    global String fullName;
    global String type;
    global EntitlementSettings() {

    }
}
global class EntitlementTemplate extends Framework.MetadataService.Metadata {
    global String businessHours;
    global Integer casesPerEntitlement;
    global String entitlementProcess;
    global String fullName;
    global Boolean isPerIncident;
    global Integer term;
    global String type;
    global String type_x;
    global EntitlementTemplate() {

    }
}
global class Error {
    global List<String> fields;
    global String message;
    global String statusCode;
    global Error() {

    }
}
global class EscalationAction {
    global String assignedTo;
    global String assignedToTemplate;
    global String assignedToType;
    global Integer minutesToEscalation;
    global Boolean notifyCaseOwner;
    global List<String> notifyEmail;
    global String notifyTo;
    global String notifyToTemplate;
    global EscalationAction() {

    }
}
global class EscalationRule extends Framework.MetadataService.Metadata {
    global Boolean active;
    global String fullName;
    global List<Framework.MetadataService.RuleEntry> ruleEntry;
    global String type;
    global EscalationRule() {

    }
}
global class EscalationRules extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.EscalationRule> escalationRule;
    global String fullName;
    global String type;
    global EscalationRules() {

    }
}
global class ExternalDataSource extends Framework.MetadataService.Metadata {
    global String apiKey;
    global String authProvider;
    global String certificate;
    global String customConfiguration;
    global String endpoint;
    global String fullName;
    global String label;
    global String oauthRefreshToken;
    global String oauthScope;
    global String oauthToken;
    global String password;
    global String principalType;
    global String protocol;
    global String repository;
    global String type;
    global String type_x;
    global String username;
    global String version;
    global ExternalDataSource() {

    }
}
global class FeedItemSettings {
    global Integer characterLimit;
    global Boolean collapseThread;
    global String displayFormat;
    global String feedItemType;
    global FeedItemSettings() {

    }
}
global class FeedLayout {
    global Boolean autocollapsePublisher;
    global Boolean compactFeed;
    global String feedFilterPosition;
    global List<Framework.MetadataService.FeedLayoutFilter> feedFilters;
    global Boolean fullWidthFeed;
    global Boolean hideSidebar;
    global List<Framework.MetadataService.FeedLayoutComponent> leftComponents;
    global List<Framework.MetadataService.FeedLayoutComponent> rightComponents;
    global FeedLayout() {

    }
}
global class FeedLayoutComponent {
    global String componentType;
    global Integer height;
    global String page_x;
    global FeedLayoutComponent() {

    }
}
global class FeedLayoutFilter {
    global String feedFilterType;
    global String feedItemType;
    global FeedLayoutFilter() {

    }
}
global class FieldOverride {
    global String field;
    global String formula;
    global String literalValue;
    global FieldOverride() {

    }
}
global class FieldSet extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.FieldSetItem> availableFields;
    global String description;
    global List<Framework.MetadataService.FieldSetItem> displayedFields;
    global String fullName;
    global String label;
    global String type;
    global FieldSet() {

    }
}
global class FieldSetItem {
    global String field;
    global Boolean isFieldManaged;
    global Boolean isRequired;
    global FieldSetItem() {

    }
}
global class FieldValue {
    global String name;
    global String value;
    global FieldValue() {

    }
}
global class FileProperties {
    global String createdById;
    global String createdByName;
    global Datetime createdDate;
    global String fileName;
    global String fullName;
    global String id;
    global String lastModifiedById;
    global String lastModifiedByName;
    global Datetime lastModifiedDate;
    global String manageableState;
    global String namespacePrefix;
    global String type_x;
    global FileProperties() {

    }
}
global class FilterItem {
    global String field;
    global String operation;
    global String value;
    global String valueField;
    global FilterItem() {

    }
}
global class FindSimilarOppFilter {
    global List<String> similarOpportunitiesDisplayColumns;
    global List<String> similarOpportunitiesMatchFields;
    global FindSimilarOppFilter() {

    }
}
global class FiscalYearSettings {
    global String fiscalYearNameBasedOn;
    global String startMonth;
    global FiscalYearSettings() {

    }
}
global class FlexiPage extends Framework.MetadataService.Metadata {
    global String description;
    global List<Framework.MetadataService.FlexiPageRegion> flexiPageRegions;
    global String fullName;
    global String masterLabel;
    global String pageTemplate;
    global Framework.MetadataService.QuickActionList quickActionList;
    global String sobjectType;
    global String type;
    global String type_x;
    global FlexiPage() {

    }
}
global class FlexiPageRegion {
    global List<Framework.MetadataService.ComponentInstance> componentInstances;
    global String name;
    global FlexiPageRegion() {

    }
}
global class Flow extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.FlowActionCall> actionCalls;
    global List<Framework.MetadataService.FlowApexPluginCall> apexPluginCalls;
    global List<Framework.MetadataService.FlowAssignment> assignments;
    global List<Framework.MetadataService.FlowChoice> choices;
    global List<Framework.MetadataService.FlowConstant> constants;
    global List<Framework.MetadataService.FlowDecision> decisions;
    global String description;
    global List<Framework.MetadataService.FlowDynamicChoiceSet> dynamicChoiceSets;
    global List<Framework.MetadataService.FlowFormula> formulas;
    global String fullName;
    global String interviewLabel;
    global String label;
    global List<Framework.MetadataService.FlowLoop> loops;
    global List<Framework.MetadataService.FlowMetadataValue> processMetadataValues;
    global String processType;
    global List<Framework.MetadataService.FlowRecordCreate> recordCreates;
    global List<Framework.MetadataService.FlowRecordDelete> recordDeletes;
    global List<Framework.MetadataService.FlowRecordLookup> recordLookups;
    global List<Framework.MetadataService.FlowRecordUpdate> recordUpdates;
    global List<Framework.MetadataService.FlowScreen> screens;
    global String startElementReference;
    global List<Framework.MetadataService.FlowStep> steps;
    global List<Framework.MetadataService.FlowSubflow> subflows;
    global List<Framework.MetadataService.FlowTextTemplate> textTemplates;
    global String type;
    global List<Framework.MetadataService.FlowVariable> variables;
    global List<Framework.MetadataService.FlowWait> waits;
    global Flow() {

    }
}
global class FlowActionCall {
    global String actionName;
    global String actionType;
    global Framework.MetadataService.FlowConnector connector;
    global Framework.MetadataService.FlowConnector faultConnector;
    global List<Framework.MetadataService.FlowActionCallInputParameter> inputParameters;
    global List<Framework.MetadataService.FlowActionCallOutputParameter> outputParameters;
    global FlowActionCall() {

    }
}
global class FlowActionCallInputParameter {
    global String name;
    global Framework.MetadataService.FlowElementReferenceOrValue value;
    global FlowActionCallInputParameter() {

    }
}
global class FlowActionCallOutputParameter {
    global String assignToReference;
    global String name;
    global FlowActionCallOutputParameter() {

    }
}
global class FlowApexPluginCall {
    global String apexClass;
    global Framework.MetadataService.FlowConnector connector;
    global Framework.MetadataService.FlowConnector faultConnector;
    global List<Framework.MetadataService.FlowApexPluginCallInputParameter> inputParameters;
    global List<Framework.MetadataService.FlowApexPluginCallOutputParameter> outputParameters;
    global FlowApexPluginCall() {

    }
}
global class FlowApexPluginCallInputParameter {
    global String name;
    global Framework.MetadataService.FlowElementReferenceOrValue value;
    global FlowApexPluginCallInputParameter() {

    }
}
global class FlowApexPluginCallOutputParameter {
    global String assignToReference;
    global String name;
    global FlowApexPluginCallOutputParameter() {

    }
}
global class FlowAssignment {
    global List<Framework.MetadataService.FlowAssignmentItem> assignmentItems;
    global Framework.MetadataService.FlowConnector connector;
    global FlowAssignment() {

    }
}
global class FlowAssignmentItem {
    global String assignToReference;
    global String operator;
    global Framework.MetadataService.FlowElementReferenceOrValue value;
    global FlowAssignmentItem() {

    }
}
global class FlowBaseElement {
    global List<Framework.MetadataService.FlowMetadataValue> processMetadataValues;
    global FlowBaseElement() {

    }
}
global class FlowChoice {
    global String choiceText;
    global String dataType;
    global Framework.MetadataService.FlowChoiceUserInput userInput;
    global Framework.MetadataService.FlowElementReferenceOrValue value;
    global FlowChoice() {

    }
}
global class FlowChoiceUserInput {
    global Boolean isRequired;
    global String promptText;
    global Framework.MetadataService.FlowInputValidationRule validationRule;
    global FlowChoiceUserInput() {

    }
}
global class FlowCondition {
    global String leftValueReference;
    global String operator;
    global Framework.MetadataService.FlowElementReferenceOrValue rightValue;
    global FlowCondition() {

    }
}
global class FlowConnector {
    global String targetReference;
    global FlowConnector() {

    }
}
global class FlowConstant {
    global String dataType;
    global Framework.MetadataService.FlowElementReferenceOrValue value;
    global FlowConstant() {

    }
}
global class FlowDecision {
    global Framework.MetadataService.FlowConnector defaultConnector;
    global String defaultConnectorLabel;
    global List<Framework.MetadataService.FlowRule> rules;
    global FlowDecision() {

    }
}
global class FlowDynamicChoiceSet {
    global String dataType;
    global String displayField;
    global List<Framework.MetadataService.FlowRecordFilter> filters;
    global Integer limit_x;
    global String object_x;
    global List<Framework.MetadataService.FlowOutputFieldAssignment> outputAssignments;
    global String sortField;
    global String sortOrder;
    global String valueField;
    global FlowDynamicChoiceSet() {

    }
}
global class FlowElement {
    global String description;
    global String name;
    global FlowElement() {

    }
}
global class FlowElementReferenceOrValue {
    global Boolean booleanValue;
    global Datetime dateTimeValue;
    global Date dateValue;
    global String elementReference;
    global Double numberValue;
    global String stringValue;
    global FlowElementReferenceOrValue() {

    }
}
global class FlowFormula {
    global String dataType;
    global String expression;
    global Integer scale;
    global FlowFormula() {

    }
}
global class FlowInputFieldAssignment {
    global String field;
    global Framework.MetadataService.FlowElementReferenceOrValue value;
    global FlowInputFieldAssignment() {

    }
}
global class FlowInputValidationRule {
    global String errorMessage;
    global String formulaExpression;
    global FlowInputValidationRule() {

    }
}
global class FlowLoop {
    global String assignNextValueToReference;
    global String collectionReference;
    global String iterationOrder;
    global Framework.MetadataService.FlowConnector nextValueConnector;
    global Framework.MetadataService.FlowConnector noMoreValuesConnector;
    global FlowLoop() {

    }
}
global class FlowMetadataValue {
    global String name;
    global Framework.MetadataService.FlowElementReferenceOrValue value;
    global FlowMetadataValue() {

    }
}
global class FlowNode {
    global String label;
    global Integer locationX;
    global Integer locationY;
    global FlowNode() {

    }
}
global class FlowOutputFieldAssignment {
    global String assignToReference;
    global String field;
    global FlowOutputFieldAssignment() {

    }
}
global class FlowRecordCreate {
    global String assignRecordIdToReference;
    global Framework.MetadataService.FlowConnector connector;
    global Framework.MetadataService.FlowConnector faultConnector;
    global List<Framework.MetadataService.FlowInputFieldAssignment> inputAssignments;
    global String inputReference;
    global String object_x;
    global FlowRecordCreate() {

    }
}
global class FlowRecordDelete {
    global Framework.MetadataService.FlowConnector connector;
    global Framework.MetadataService.FlowConnector faultConnector;
    global List<Framework.MetadataService.FlowRecordFilter> filters;
    global String inputReference;
    global String object_x;
    global FlowRecordDelete() {

    }
}
global class FlowRecordFilter {
    global String field;
    global String operator;
    global Framework.MetadataService.FlowElementReferenceOrValue value;
    global FlowRecordFilter() {

    }
}
global class FlowRecordLookup {
    global Boolean assignNullValuesIfNoRecordsFound;
    global Framework.MetadataService.FlowConnector connector;
    global Framework.MetadataService.FlowConnector faultConnector;
    global List<Framework.MetadataService.FlowRecordFilter> filters;
    global String object_x;
    global List<Framework.MetadataService.FlowOutputFieldAssignment> outputAssignments;
    global String outputReference;
    global List<String> queriedFields;
    global String sortField;
    global String sortOrder;
    global FlowRecordLookup() {

    }
}
global class FlowRecordUpdate {
    global Framework.MetadataService.FlowConnector connector;
    global Framework.MetadataService.FlowConnector faultConnector;
    global List<Framework.MetadataService.FlowRecordFilter> filters;
    global List<Framework.MetadataService.FlowInputFieldAssignment> inputAssignments;
    global String inputReference;
    global String object_x;
    global FlowRecordUpdate() {

    }
}
global class FlowRule {
    global String conditionLogic;
    global List<Framework.MetadataService.FlowCondition> conditions;
    global Framework.MetadataService.FlowConnector connector;
    global String label;
    global FlowRule() {

    }
}
global class FlowScreen {
    global Boolean allowBack;
    global Boolean allowFinish;
    global Boolean allowPause;
    global Framework.MetadataService.FlowConnector connector;
    global List<Framework.MetadataService.FlowScreenField> fields;
    global String helpText;
    global String pausedText;
    global FlowScreen() {

    }
}
global class FlowScreenField {
    global List<String> choiceReferences;
    global String dataType;
    global String defaultSelectedChoiceReference;
    global Framework.MetadataService.FlowElementReferenceOrValue defaultValue;
    global String fieldText;
    global String fieldType;
    global String helpText;
    global Boolean isRequired;
    global Integer scale;
    global Framework.MetadataService.FlowInputValidationRule validationRule;
    global FlowScreenField() {

    }
}
global class FlowStep {
    global List<Framework.MetadataService.FlowConnector> connectors;
    global FlowStep() {

    }
}
global class FlowSubflow {
    global Framework.MetadataService.FlowConnector connector;
    global String flowName;
    global List<Framework.MetadataService.FlowSubflowInputAssignment> inputAssignments;
    global List<Framework.MetadataService.FlowSubflowOutputAssignment> outputAssignments;
    global FlowSubflow() {

    }
}
global class FlowSubflowInputAssignment {
    global String name;
    global Framework.MetadataService.FlowElementReferenceOrValue value;
    global FlowSubflowInputAssignment() {

    }
}
global class FlowSubflowOutputAssignment {
    global String assignToReference;
    global String name;
    global FlowSubflowOutputAssignment() {

    }
}
global class FlowTextTemplate {
    global String text;
    global FlowTextTemplate() {

    }
}
global class FlowVariable {
    global String dataType;
    global Boolean isCollection;
    global Boolean isInput;
    global Boolean isOutput;
    global String objectType;
    global Integer scale;
    global Framework.MetadataService.FlowElementReferenceOrValue value;
    global FlowVariable() {

    }
}
global class FlowWait {
    global Framework.MetadataService.FlowConnector defaultConnector;
    global String defaultConnectorLabel;
    global Framework.MetadataService.FlowConnector faultConnector;
    global List<Framework.MetadataService.FlowWaitEvent> waitEvents;
    global FlowWait() {

    }
}
global class FlowWaitEvent {
    global String conditionLogic;
    global List<Framework.MetadataService.FlowCondition> conditions;
    global Framework.MetadataService.FlowConnector connector;
    global String eventType;
    global List<Framework.MetadataService.FlowWaitEventInputParameter> inputParameters;
    global String label;
    global List<Framework.MetadataService.FlowWaitEventOutputParameter> outputParameters;
    global FlowWaitEvent() {

    }
}
global class FlowWaitEventInputParameter {
    global String name;
    global Framework.MetadataService.FlowElementReferenceOrValue value;
    global FlowWaitEventInputParameter() {

    }
}
global class FlowWaitEventOutputParameter {
    global String assignToReference;
    global String name;
    global FlowWaitEventOutputParameter() {

    }
}
global virtual class Folder extends Framework.MetadataService.Metadata {
    global String accessType;
    global List<Framework.MetadataService.FolderShare> folderShares;
    global String name;
    global String publicFolderAccess;
    global Framework.MetadataService.SharedTo sharedTo;
    global Folder() {

    }
}
global class FolderShare {
    global String accessLevel;
    global String sharedTo;
    global String sharedToType;
    global FolderShare() {

    }
}
global class ForecastRangeSettings {
    global Integer beginning;
    global Integer displaying;
    global String periodType;
    global ForecastRangeSettings() {

    }
}
global class ForecastingSettings extends Framework.MetadataService.Metadata {
    global String displayCurrency;
    global Boolean enableForecasts;
    global List<Framework.MetadataService.ForecastingTypeSettings> forecastingTypeSettings;
    global String fullName;
    global String type;
    global ForecastingSettings() {

    }
}
global class ForecastingTypeSettings {
    global Boolean active;
    global Framework.MetadataService.AdjustmentsSettings adjustmentsSettings;
    global Framework.MetadataService.ForecastRangeSettings forecastRangeSettings;
    global String name;
    global Framework.MetadataService.OpportunityListFieldsSelectedSettings opportunityListFieldsSelectedSettings;
    global Framework.MetadataService.QuotasSettings quotasSettings;
    global ForecastingTypeSettings() {

    }
}
global class GlobalQuickActionTranslation {
    global String label;
    global String name;
    global GlobalQuickActionTranslation() {

    }
}
global class Group_x extends Framework.MetadataService.Metadata {
    global Boolean doesIncludeBosses;
    global String fullName;
    global String name;
    global String type;
    global Group_x() {

    }
}
global class HistoryRetentionPolicy {
    global Integer archiveAfterMonths;
    global Integer archiveRetentionYears;
    global String description;
    global HistoryRetentionPolicy() {

    }
}
global class Holiday {
    global Date activityDate;
    global List<String> businessHours;
    global String description;
    global Datetime endTime;
    global Boolean isRecurring;
    global String name;
    global Integer recurrenceDayOfMonth;
    global List<String> recurrenceDayOfWeek;
    global Integer recurrenceDayOfWeekMask;
    global Date recurrenceEndDate;
    global String recurrenceInstance;
    global Integer recurrenceInterval;
    global String recurrenceMonthOfYear;
    global Date recurrenceStartDate;
    global String recurrenceType;
    global Datetime startTime;
    global Holiday() {

    }
}
global class HomePageComponent extends Framework.MetadataService.Metadata {
    global String body;
    global String fullName;
    global Integer height;
    global List<String> links;
    global String page_x;
    global String pageComponentType;
    global Boolean showLabel;
    global Boolean showScrollbars;
    global String type;
    global String width;
    global HomePageComponent() {

    }
}
global class HomePageLayout extends Framework.MetadataService.Metadata {
    global String fullName;
    global List<String> narrowComponents;
    global String type;
    global List<String> wideComponents;
    global HomePageLayout() {

    }
}
global interface IReadResponseElement {
    Framework.MetadataService.IReadResult getResult();
}
global interface IReadResult {
    List<Framework.MetadataService.Metadata> getRecords();
}
global class IdeaReputationLevel {
    global String name;
    global Integer value;
    global IdeaReputationLevel() {

    }
}
global class IdeasSettings extends Framework.MetadataService.Metadata {
    global Boolean enableChatterProfile;
    global Boolean enableIdeas;
    global Boolean enableIdeasReputation;
    global Boolean enableIdeaThemes;
    global String fullName;
    global Double halfLife;
    global String ideasProfilePage;
    global String type;
    global IdeasSettings() {

    }
}
global class InstalledPackage extends Framework.MetadataService.Metadata {
    global String fullName;
    global String password;
    global String type;
    global String versionNumber;
    global InstalledPackage() {

    }
}
global class IpRange {
    global String end_x;
    global String start;
    global IpRange() {

    }
}
global class KeyboardShortcuts {
    global List<Framework.MetadataService.CustomShortcut> customShortcut;
    global List<Framework.MetadataService.DefaultShortcut> defaultShortcut;
    global KeyboardShortcuts() {

    }
}
global class KnowledgeAnswerSettings {
    global String assignTo;
    global String defaultArticleType;
    global Boolean enableArticleCreation;
    global KnowledgeAnswerSettings() {

    }
}
global class KnowledgeCaseSettings {
    global String articlePDFCreationProfile;
    global Framework.MetadataService.KnowledgeSitesSettings articlePublicSharingSites;
    global Framework.MetadataService.KnowledgeSitesSettings articlePublicSharingSitesChatterAnswers;
    global String assignTo;
    global String customizationClass;
    global String defaultContributionArticleType;
    global String editor;
    global Boolean enableArticleCreation;
    global Boolean enableArticlePublicSharingSites;
    global Boolean useProfileForPDFCreation;
    global KnowledgeCaseSettings() {

    }
}
global class KnowledgeLanguage {
    global Boolean active;
    global String defaultAssignee;
    global String defaultAssigneeType;
    global String defaultReviewer;
    global String defaultReviewerType;
    global String name;
    global KnowledgeLanguage() {

    }
}
global class KnowledgeLanguageSettings {
    global List<Framework.MetadataService.KnowledgeLanguage> language;
    global KnowledgeLanguageSettings() {

    }
}
global class KnowledgeSettings extends Framework.MetadataService.Metadata {
    global Framework.MetadataService.KnowledgeAnswerSettings answers;
    global Framework.MetadataService.KnowledgeCaseSettings cases;
    global String defaultLanguage;
    global Boolean enableChatterQuestionKBDeflection;
    global Boolean enableCreateEditOnArticlesTab;
    global Boolean enableExternalMediaContent;
    global Boolean enableKnowledge;
    global String fullName;
    global Framework.MetadataService.KnowledgeLanguageSettings languages;
    global Boolean showArticleSummariesCustomerPortal;
    global Boolean showArticleSummariesInternalApp;
    global Boolean showArticleSummariesPartnerPortal;
    global Boolean showValidationStatusField;
    global String type;
    global KnowledgeSettings() {

    }
}
global class KnowledgeSitesSettings {
    global List<String> site;
    global KnowledgeSitesSettings() {

    }
}
global class Layout extends Framework.MetadataService.Metadata {
    global List<String> customButtons;
    global Framework.MetadataService.CustomConsoleComponents customConsoleComponents;
    global Boolean emailDefault;
    global List<String> excludeButtons;
    global Framework.MetadataService.FeedLayout feedLayout;
    global String fullName;
    global List<String> headers;
    global List<Framework.MetadataService.LayoutSection> layoutSections;
    global Framework.MetadataService.MiniLayout miniLayout;
    global List<String> multilineLayoutFields;
    global Framework.MetadataService.QuickActionList quickActionList;
    global Framework.MetadataService.RelatedContent relatedContent;
    global List<Framework.MetadataService.RelatedListItem> relatedLists;
    global List<String> relatedObjects;
    global Boolean runAssignmentRulesDefault;
    global Boolean showEmailCheckbox;
    global Boolean showHighlightsPanel;
    global Boolean showInteractionLogPanel;
    global Boolean showKnowledgeComponent;
    global Boolean showRunAssignmentRulesCheckbox;
    global Boolean showSolutionSection;
    global Boolean showSubmitAndAttachButton;
    global Framework.MetadataService.SummaryLayout summaryLayout;
    global String type;
    global Layout() {

    }
}
global class LayoutColumn {
    global List<Framework.MetadataService.LayoutItem> layoutItems;
    global String reserved;
    global LayoutColumn() {

    }
}
global class LayoutItem {
    global String behavior;
    global String canvas;
    global String component;
    global String customLink;
    global Boolean emptySpace;
    global String field;
    global Integer height;
    global String page_x;
    global Framework.MetadataService.ReportChartComponentLayoutItem reportChartComponent;
    global String scontrol;
    global Boolean showLabel;
    global Boolean showScrollbars;
    global String width;
    global LayoutItem() {

    }
}
global class LayoutSection {
    global Boolean customLabel;
    global Boolean detailHeading;
    global Boolean editHeading;
    global String label;
    global List<Framework.MetadataService.LayoutColumn> layoutColumns;
    global String style;
    global LayoutSection() {

    }
}
global class LayoutSectionTranslation {
    global String label;
    global String section;
    global LayoutSectionTranslation() {

    }
}
global class LayoutTranslation {
    global String layout;
    global String layoutType;
    global List<Framework.MetadataService.LayoutSectionTranslation> sections;
    global LayoutTranslation() {

    }
}
global class Letterhead extends Framework.MetadataService.Metadata {
    global Boolean available;
    global String backgroundColor;
    global String bodyColor;
    global Framework.MetadataService.LetterheadLine bottomLine;
    global String description;
    global Framework.MetadataService.LetterheadHeaderFooter footer;
    global String fullName;
    global Framework.MetadataService.LetterheadHeaderFooter header;
    global Framework.MetadataService.LetterheadLine middleLine;
    global String name;
    global Framework.MetadataService.LetterheadLine topLine;
    global String type;
    global Letterhead() {

    }
}
global class LetterheadHeaderFooter {
    global String backgroundColor;
    global Integer height;
    global String horizontalAlignment;
    global String logo;
    global String verticalAlignment;
    global LetterheadHeaderFooter() {

    }
}
global class LetterheadLine {
    global String color;
    global Integer height;
    global LetterheadLine() {

    }
}
global class LicenseDefinition extends Framework.MetadataService.Metadata {
    global String aggregationGroup;
    global String description;
    global String fullName;
    global Boolean isPublished;
    global String label;
    global List<Framework.MetadataService.LicensedCustomPermissions> licensedCustomPermissions;
    global String licensingAuthority;
    global String licensingAuthorityProvider;
    global Integer minPlatformVersion;
    global String origin;
    global Integer revision;
    global Integer trialLicenseDuration;
    global Integer trialLicenseQuantity;
    global String type;
    global LicenseDefinition() {

    }
}
global class LicensedCustomPermissions {
    global String customPermission;
    global String licenseDefinition;
    global LicensedCustomPermissions() {

    }
}
global class ListMetadataQuery {
    global String folder;
    global String type_x;
    global ListMetadataQuery() {

    }
}
global class ListPlacement {
    global Integer height;
    global String location;
    global String units;
    global Integer width;
    global ListPlacement() {

    }
}
global class ListView extends Framework.MetadataService.Metadata {
    global String booleanFilter;
    global List<String> columns;
    global String division;
    global List<Framework.MetadataService.ListViewFilter> filters;
    global String filterScope;
    global String fullName;
    global String label;
    global String language;
    global String queue;
    global Framework.MetadataService.SharedTo sharedTo;
    global String type;
    global ListView() {

    }
}
global class ListViewFilter {
    global String field;
    global String operation;
    global String value;
    global ListViewFilter() {

    }
}
global class LiveAgentConfig {
    global Boolean enableLiveChat;
    global Boolean openNewAccountSubtab;
    global Boolean openNewCaseSubtab;
    global Boolean openNewContactSubtab;
    global Boolean openNewLeadSubtab;
    global Boolean openNewVFPageSubtab;
    global Framework.MetadataService.PagesToOpen pagesToOpen;
    global Boolean showKnowledgeArticles;
    global LiveAgentConfig() {

    }
}
global class LiveAgentSettings extends Framework.MetadataService.Metadata {
    global Boolean enableLiveAgent;
    global String fullName;
    global String type;
    global LiveAgentSettings() {

    }
}
global class LiveChatAgentConfig extends Framework.MetadataService.Metadata {
    global Framework.MetadataService.AgentConfigAssignments assignments;
    global String autoGreeting;
    global Integer capacity;
    global Integer criticalWaitTime;
    global String customAgentName;
    global Boolean enableAgentFileTransfer;
    global Boolean enableAgentSneakPeek;
    global Boolean enableAutoAwayOnDecline;
    global Boolean enableChatMonitoring;
    global Boolean enableChatTransfer;
    global Boolean enableLogoutSound;
    global Boolean enableNotifications;
    global Boolean enableRequestSound;
    global Boolean enableSneakPeek;
    global Boolean enableWhisperMessage;
    global String fullName;
    global String label;
    global String supervisorDefaultAgentStatusFilter;
    global String supervisorDefaultButtonFilter;
    global String supervisorDefaultSkillFilter;
    global Framework.MetadataService.SupervisorAgentConfigSkills supervisorSkills;
    global Framework.MetadataService.AgentConfigButtons transferableButtons;
    global Framework.MetadataService.AgentConfigSkills transferableSkills;
    global String type;
    global LiveChatAgentConfig() {

    }
}
global class LiveChatButton extends Framework.MetadataService.Metadata {
    global String animation;
    global String autoGreeting;
    global String chatPage;
    global String customAgentName;
    global Framework.MetadataService.LiveChatButtonDeployments deployments;
    global Boolean enableQueue;
    global String fullName;
    global String inviteEndPosition;
    global String inviteImage;
    global String inviteStartPosition;
    global Boolean isActive;
    global String label;
    global Integer numberOfReroutingAttempts;
    global String offlineImage;
    global String onlineImage;
    global Boolean optionsCustomRoutingIsEnabled;
    global Boolean optionsHasInviteAfterAccept;
    global Boolean optionsHasInviteAfterReject;
    global Boolean optionsHasRerouteDeclinedRequest;
    global Boolean optionsIsAutoAccept;
    global Boolean optionsIsInviteAutoRemove;
    global Integer overallQueueLength;
    global Integer perAgentQueueLength;
    global String postChatPage;
    global String postChatUrl;
    global String preChatFormPage;
    global String preChatFormUrl;
    global Integer pushTimeOut;
    global String routingType;
    global String site;
    global Framework.MetadataService.LiveChatButtonSkills skills;
    global Integer timeToRemoveInvite;
    global String type;
    global String type_x;
    global String windowLanguage;
    global LiveChatButton() {

    }
}
global class LiveChatButtonDeployments {
    global List<String> deployment;
    global LiveChatButtonDeployments() {

    }
}
global class LiveChatButtonSkills {
    global List<String> skill;
    global LiveChatButtonSkills() {

    }
}
global class LiveChatDeployment extends Framework.MetadataService.Metadata {
    global String brandingImage;
    global Boolean displayQueuePosition;
    global Framework.MetadataService.LiveChatDeploymentDomainWhitelist domainWhiteList;
    global Boolean enablePrechatApi;
    global Boolean enableTranscriptSave;
    global String fullName;
    global String label;
    global String mobileBrandingImage;
    global String site;
    global String type;
    global String windowTitle;
    global LiveChatDeployment() {

    }
}
global class LiveChatDeploymentDomainWhitelist {
    global List<String> domain;
    global LiveChatDeploymentDomainWhitelist() {

    }
}
global class LogInfo {
    global String category;
    global String level;
    global LogInfo() {

    }
}
global class LookupFilter {
    global Boolean active;
    global String booleanFilter;
    global String description;
    global String errorMessage;
    global List<Framework.MetadataService.FilterItem> filterItems;
    global String infoMessage;
    global Boolean isOptional;
    global LookupFilter() {

    }
}
global class LookupFilterTranslation {
    global String errorMessage;
    global String informationalMessage;
    global LookupFilterTranslation() {

    }
}
global class ManagedTopic {
    global String managedTopicType;
    global String name;
    global Integer position;
    global String topicDescription;
    global ManagedTopic() {

    }
}
global class ManagedTopics extends Framework.MetadataService.Metadata {
    global String fullName;
    global List<Framework.MetadataService.ManagedTopic> managedTopic;
    global String type;
    global ManagedTopics() {

    }
}
global class MarketingActionSettings extends Framework.MetadataService.Metadata {
    global Boolean enableMarketingAction;
    global String fullName;
    global String type;
    global MarketingActionSettings() {

    }
}
global class MarketingResourceType extends Framework.MetadataService.Metadata {
    global String description;
    global String fullName;
    global String masterLabel;
    global String object_x;
    global String provider;
    global String type;
    global MarketingResourceType() {

    }
}
global class MatchingRule extends Framework.MetadataService.Metadata {
    global String booleanFilter;
    global String description;
    global String fullName;
    global String label;
    global List<Framework.MetadataService.MatchingRuleItem> matchingRuleItems;
    global String ruleStatus;
    global String type;
    global MatchingRule() {

    }
}
global class MatchingRuleItem {
    global String blankValueBehavior;
    global String fieldName;
    global String matchingMethod;
    global MatchingRuleItem() {

    }
}
global class MatchingRules extends Framework.MetadataService.Metadata {
    global String fullName;
    global List<Framework.MetadataService.MatchingRule> matchingRules;
    global String type;
    global MatchingRules() {

    }
}
global virtual class Metadata {
    global String fullName;
    global Metadata() {

    }
}
global class MetadataPort {
    global Framework.MetadataService.CallOptions_element CallOptions;
    global String clientCert_x;
    global String clientCertName_x;
    global String clientCertPasswd_x;
    global Framework.MetadataService.DebuggingHeader_element DebuggingHeader;
    global Framework.MetadataService.DebuggingInfo_element DebuggingInfo;
    global String endpoint_x;
    global Map<String,String> inputHttpHeaders_x;
    global Map<String,String> outputHttpHeaders_x;
    global Framework.MetadataService.SessionHeader_element SessionHeader;
    global Integer timeout_x;
    global MetadataPort() {

    }
    global Framework.MetadataService.CancelDeployResult cancelDeploy(String String_x) {
        return null;
    }
    global Framework.MetadataService.DeployResult checkDeployStatus(String asyncProcessId, Boolean includeDetails) {
        return null;
    }
    global Framework.MetadataService.RetrieveResult checkRetrieveStatus(String asyncProcessId) {
        return null;
    }
    global List<Framework.MetadataService.SaveResult> createMetadata(List<Framework.MetadataService.Metadata> metadata) {
        return null;
    }
    global List<Framework.MetadataService.DeleteResult> deleteMetadata(String type_x, List<String> fullNames) {
        return null;
    }
    global Framework.MetadataService.AsyncResult deploy(String ZipFile, Framework.MetadataService.DeployOptions DeployOptions) {
        return null;
    }
    global String deployRecentValidation(String validationId) {
        return null;
    }
    global Framework.MetadataService.DescribeMetadataResult describeMetadata(Double asOfVersion) {
        return null;
    }
    global Framework.MetadataService.DescribeValueTypeResult describeValueType(String type_x) {
        return null;
    }
    global List<Framework.MetadataService.FileProperties> listMetadata(List<Framework.MetadataService.ListMetadataQuery> queries, Double asOfVersion) {
        return null;
    }
    global Framework.MetadataService.IReadResult readMetadata(String type_x, List<String> fullNames) {
        return null;
    }
    global Framework.MetadataService.SaveResult renameMetadata(String type_x, String oldFullName, String newFullName) {
        return null;
    }
    global Framework.MetadataService.AsyncResult retrieve(Framework.MetadataService.RetrieveRequest retrieveRequest) {
        return null;
    }
    global List<Framework.MetadataService.SaveResult> updateMetadata(List<Framework.MetadataService.Metadata> metadata) {
        return null;
    }
    global List<Framework.MetadataService.UpsertResult> upsertMetadata(List<Framework.MetadataService.Metadata> metadata) {
        return null;
    }
}
global virtual class MetadataWithContent extends Framework.MetadataService.Metadata {
    global String content;
    global MetadataWithContent() {

    }
}
global class MilestoneType extends Framework.MetadataService.Metadata {
    global String description;
    global String fullName;
    global String recurrenceType;
    global String type;
    global MilestoneType() {

    }
}
global class MiniLayout {
    global List<String> fields;
    global List<Framework.MetadataService.RelatedListItem> relatedLists;
    global MiniLayout() {

    }
}
global class MobileSettings extends Framework.MetadataService.Metadata {
    global Framework.MetadataService.ChatterMobileSettings chatterMobile;
    global Framework.MetadataService.DashboardMobileSettings dashboardMobile;
    global String fullName;
    global Framework.MetadataService.SFDCMobileSettings salesforceMobile;
    global Framework.MetadataService.TouchMobileSettings touchMobile;
    global String type;
    global MobileSettings() {

    }
}
global class NameSettings extends Framework.MetadataService.Metadata {
    global Boolean enableMiddleName;
    global Boolean enableNameSuffix;
    global String fullName;
    global String type;
    global NameSettings() {

    }
}
global class NamedCredential extends Framework.MetadataService.Metadata {
    global String authProvider;
    global String certificate;
    global String endpoint;
    global String fullName;
    global String label;
    global String oauthRefreshToken;
    global String oauthScope;
    global String oauthToken;
    global String password;
    global String principalType;
    global String protocol;
    global String type;
    global String username;
    global NamedCredential() {

    }
}
global class Network extends Framework.MetadataService.Metadata {
    global Boolean allowMembersToFlag;
    global Framework.MetadataService.Branding branding;
    global String caseCommentEmailTemplate;
    global String changePasswordTemplate;
    global String description;
    global String emailSenderAddress;
    global String emailSenderName;
    global Boolean enableGuestChatter;
    global Boolean enableInvitation;
    global Boolean enableKnowledgeable;
    global Boolean enableNicknameDisplay;
    global Boolean enablePrivateMessages;
    global Boolean enableReputation;
    global String feedChannel;
    global String forgotPasswordTemplate;
    global String fullName;
    global String logoutUrl;
    global Framework.MetadataService.NetworkMemberGroup networkMemberGroups;
    global String newSenderAddress;
    global String picassoSite;
    global Framework.MetadataService.ReputationLevelDefinitions reputationLevels;
    global Framework.MetadataService.ReputationPointsRules reputationPointsRules;
    global Boolean selfRegistration;
    global String selfRegProfile;
    global Boolean sendWelcomeEmail;
    global String site;
    global String status;
    global Framework.MetadataService.NetworkTabSet tabs;
    global String type;
    global String urlPathPrefix;
    global String welcomeTemplate;
    global Network() {

    }
}
global class NetworkAccess {
    global List<Framework.MetadataService.IpRange> ipRanges;
    global NetworkAccess() {

    }
}
global class NetworkMemberGroup {
    global List<String> permissionSet;
    global List<String> profile;
    global NetworkMemberGroup() {

    }
}
global class NetworkTabSet {
    global List<String> customTab;
    global String defaultTab;
    global List<String> standardTab;
    global NetworkTabSet() {

    }
}
global class NextAutomatedApprover {
    global Boolean useApproverFieldOfRecordOwner;
    global String userHierarchyField;
    global NextAutomatedApprover() {

    }
}
global class ObjectNameCaseValue {
    global String article;
    global String caseType;
    global Boolean plural;
    global String possessive;
    global String value;
    global ObjectNameCaseValue() {

    }
}
global class ObjectRelationship {
    global Framework.MetadataService.ObjectRelationship join_x;
    global Boolean outerJoin;
    global String relationship;
    global ObjectRelationship() {

    }
}
global class ObjectUsage {
    global List<String> object_x;
    global ObjectUsage() {

    }
}
global class OpportunityListFieldsSelectedSettings {
    global List<String> field;
    global OpportunityListFieldsSelectedSettings() {

    }
}
global class OpportunitySettings extends Framework.MetadataService.Metadata {
    global Boolean autoActivateNewReminders;
    global Boolean enableFindSimilarOpportunities;
    global Boolean enableOpportunityTeam;
    global Boolean enableUpdateReminders;
    global Framework.MetadataService.FindSimilarOppFilter findSimilarOppFilter;
    global String fullName;
    global Boolean promptToAddProducts;
    global String type;
    global OpportunitySettings() {

    }
}
global class OrderSettings extends Framework.MetadataService.Metadata {
    global Boolean enableNegativeQuantity;
    global Boolean enableOrders;
    global Boolean enableReductionOrders;
    global String fullName;
    global String type;
    global OrderSettings() {

    }
}
global class PackageTypeMembers {
    global List<String> members;
    global String name;
    global PackageTypeMembers() {

    }
}
global class PackageVersion {
    global Integer majorNumber;
    global Integer minorNumber;
    global String namespace;
    global PackageVersion() {

    }
}
global class Package_x extends Framework.MetadataService.Metadata {
    global String apiAccessLevel;
    global String description;
    global String fullName;
    global String namespacePrefix;
    global List<Framework.MetadataService.ProfileObjectPermissions> objectPermissions;
    global String postInstallClass;
    global String setupWeblink;
    global String type;
    global List<Framework.MetadataService.PackageTypeMembers> types;
    global String uninstallClass;
    global String version;
    global Package_x() {

    }
}
global class PagesToOpen {
    global List<String> pageToOpen;
    global PagesToOpen() {

    }
}
global class PasswordPolicies {
    global String apiOnlyUserHomePageURL;
    global String complexity;
    global String expiration;
    global String historyRestriction;
    global String lockoutInterval;
    global String maxLoginAttempts;
    global Boolean minimumPasswordLifetime;
    global String minPasswordLength;
    global Boolean obscureSecretAnswer;
    global String passwordAssistanceMessage;
    global String passwordAssistanceURL;
    global String questionRestriction;
    global PasswordPolicies() {

    }
}
global class PermissionSet extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.PermissionSetApplicationVisibility> applicationVisibilities;
    global List<Framework.MetadataService.PermissionSetApexClassAccess> classAccesses;
    global List<Framework.MetadataService.PermissionSetCustomPermissions> customPermissions;
    global String description;
    global List<Framework.MetadataService.PermissionSetExternalDataSourceAccess> externalDataSourceAccesses;
    global List<Framework.MetadataService.PermissionSetFieldPermissions> fieldPermissions;
    global String fullName;
    global String label;
    global List<Framework.MetadataService.PermissionSetObjectPermissions> objectPermissions;
    global List<Framework.MetadataService.PermissionSetApexPageAccess> pageAccesses;
    global List<Framework.MetadataService.PermissionSetRecordTypeVisibility> recordTypeVisibilities;
    global List<Framework.MetadataService.PermissionSetTabSetting> tabSettings;
    global String type;
    global String userLicense;
    global List<Framework.MetadataService.PermissionSetUserPermission> userPermissions;
    global PermissionSet() {

    }
}
global class PermissionSetApexClassAccess {
    global String apexClass;
    global Boolean enabled;
    global PermissionSetApexClassAccess() {

    }
}
global class PermissionSetApexPageAccess {
    global String apexPage;
    global Boolean enabled;
    global PermissionSetApexPageAccess() {

    }
}
global class PermissionSetApplicationVisibility {
    global String application;
    global Boolean visible;
    global PermissionSetApplicationVisibility() {

    }
}
global class PermissionSetCustomPermissions {
    global Boolean enabled;
    global String name;
    global PermissionSetCustomPermissions() {

    }
}
global class PermissionSetExternalDataSourceAccess {
    global Boolean enabled;
    global String externalDataSource;
    global PermissionSetExternalDataSourceAccess() {

    }
}
global class PermissionSetFieldPermissions {
    global Boolean editable;
    global String field;
    global Boolean readable;
    global PermissionSetFieldPermissions() {

    }
}
global class PermissionSetObjectPermissions {
    global Boolean allowCreate;
    global Boolean allowDelete;
    global Boolean allowEdit;
    global Boolean allowRead;
    global Boolean modifyAllRecords;
    global String object_x;
    global Boolean viewAllRecords;
    global PermissionSetObjectPermissions() {

    }
}
global class PermissionSetRecordTypeVisibility {
    global String recordType;
    global Boolean visible;
    global PermissionSetRecordTypeVisibility() {

    }
}
global class PermissionSetTabSetting {
    global String tab;
    global String visibility;
    global PermissionSetTabSetting() {

    }
}
global class PermissionSetUserPermission {
    global Boolean enabled;
    global String name;
    global PermissionSetUserPermission() {

    }
}
global class PersonListSettings {
    global Boolean enablePersonList;
    global PersonListSettings() {

    }
}
global class PersonalJourneySettings extends Framework.MetadataService.Metadata {
    global Boolean enableExactTargetForSalesforceApps;
    global String fullName;
    global String type;
    global PersonalJourneySettings() {

    }
}
global class Picklist {
    global String controllingField;
    global List<Framework.MetadataService.PicklistValue> picklistValues;
    global Boolean sorted;
    global Picklist() {

    }
}
global class PicklistEntry {
    global Boolean active;
    global Boolean defaultValue;
    global String label;
    global String validFor;
    global String value;
    global PicklistEntry() {

    }
}
global class PicklistValue extends Framework.MetadataService.Metadata {
    global Boolean allowEmail;
    global Boolean closed;
    global String color;
    global List<String> controllingFieldValues;
    global Boolean converted;
    global Boolean cssExposed;
    global Boolean default_x;
    global String description;
    global String forecastCategory;
    global String fullName;
    global Boolean highPriority;
    global Integer probability;
    global String reverseRole;
    global Boolean reviewed;
    global String type;
    global Boolean won;
    global PicklistValue() {

    }
}
global class PicklistValueTranslation {
    global String masterLabel;
    global String translation;
    global PicklistValueTranslation() {

    }
}
global class Portal extends Framework.MetadataService.Metadata {
    global Boolean active;
    global String admin;
    global String defaultLanguage;
    global String description;
    global String emailSenderAddress;
    global String emailSenderName;
    global Boolean enableSelfCloseCase;
    global String footerDocument;
    global String forgotPassTemplate;
    global String fullName;
    global String headerDocument;
    global Boolean isSelfRegistrationActivated;
    global String loginHeaderDocument;
    global String logoDocument;
    global String logoutUrl;
    global String newCommentTemplate;
    global String newPassTemplate;
    global String newUserTemplate;
    global String ownerNotifyTemplate;
    global String selfRegNewUserUrl;
    global String selfRegUserDefaultProfile;
    global String selfRegUserDefaultRole;
    global String selfRegUserTemplate;
    global Boolean showActionConfirmation;
    global String stylesheetDocument;
    global String type;
    global String type_x;
    global Portal() {

    }
}
global class PostTemplate extends Framework.MetadataService.Metadata {
    global Boolean default_x;
    global String description;
    global List<String> fields;
    global String fullName;
    global String label;
    global String type;
    global PostTemplate() {

    }
}
global class PrimaryTabComponents {
    global List<Framework.MetadataService.Container> containers;
    global PrimaryTabComponents() {

    }
}
global class ProductSettings extends Framework.MetadataService.Metadata {
    global Boolean enableCascadeActivateToRelatedPrices;
    global Boolean enableQuantitySchedule;
    global Boolean enableRevenueSchedule;
    global String fullName;
    global String type;
    global ProductSettings() {

    }
}
global class Profile extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.ProfileApplicationVisibility> applicationVisibilities;
    global List<Framework.MetadataService.ProfileApexClassAccess> classAccesses;
    global Boolean custom;
    global List<Framework.MetadataService.ProfileCustomPermissions> customPermissions;
    global String description;
    global List<Framework.MetadataService.ProfileExternalDataSourceAccess> externalDataSourceAccesses;
    global List<Framework.MetadataService.ProfileFieldLevelSecurity> fieldPermissions;
    global String fullName;
    global List<Framework.MetadataService.ProfileLayoutAssignment> layoutAssignments;
    global Framework.MetadataService.ProfileLoginHours loginHours;
    global List<Framework.MetadataService.ProfileLoginIpRange> loginIpRanges;
    global List<Framework.MetadataService.ProfileObjectPermissions> objectPermissions;
    global List<Framework.MetadataService.ProfileApexPageAccess> pageAccesses;
    global List<Framework.MetadataService.ProfileRecordTypeVisibility> recordTypeVisibilities;
    global List<Framework.MetadataService.ProfileTabVisibility> tabVisibilities;
    global String type;
    global String userLicense;
    global List<Framework.MetadataService.ProfileUserPermission> userPermissions;
    global Profile() {

    }
}
global class ProfileApexClassAccess {
    global String apexClass;
    global Boolean enabled;
    global ProfileApexClassAccess() {

    }
}
global class ProfileApexPageAccess {
    global String apexPage;
    global Boolean enabled;
    global ProfileApexPageAccess() {

    }
}
global class ProfileApplicationVisibility {
    global String application;
    global Boolean default_x;
    global Boolean visible;
    global ProfileApplicationVisibility() {

    }
}
global class ProfileCustomPermissions {
    global Boolean enabled;
    global String name;
    global ProfileCustomPermissions() {

    }
}
global class ProfileExternalDataSourceAccess {
    global Boolean enabled;
    global String externalDataSource;
    global ProfileExternalDataSourceAccess() {

    }
}
global class ProfileFieldLevelSecurity {
    global Boolean editable;
    global String field;
    global Boolean readable;
    global ProfileFieldLevelSecurity() {

    }
}
global class ProfileLayoutAssignment {
    global String layout;
    global String recordType;
    global ProfileLayoutAssignment() {

    }
}
global class ProfileLoginHours {
    global String fridayEnd;
    global String fridayStart;
    global String mondayEnd;
    global String mondayStart;
    global String saturdayEnd;
    global String saturdayStart;
    global String sundayEnd;
    global String sundayStart;
    global String thursdayEnd;
    global String thursdayStart;
    global String tuesdayEnd;
    global String tuesdayStart;
    global String wednesdayEnd;
    global String wednesdayStart;
    global ProfileLoginHours() {

    }
}
global class ProfileLoginIpRange {
    global String description;
    global String endAddress;
    global String startAddress;
    global ProfileLoginIpRange() {

    }
}
global class ProfileObjectPermissions {
    global Boolean allowCreate;
    global Boolean allowDelete;
    global Boolean allowEdit;
    global Boolean allowRead;
    global Boolean modifyAllRecords;
    global String object_x;
    global Boolean viewAllRecords;
    global ProfileObjectPermissions() {

    }
}
global class ProfileRecordTypeVisibility {
    global Boolean default_x;
    global Boolean personAccountDefault;
    global String recordType;
    global Boolean visible;
    global ProfileRecordTypeVisibility() {

    }
}
global class ProfileTabVisibility {
    global String tab;
    global String visibility;
    global ProfileTabVisibility() {

    }
}
global class ProfileUserPermission {
    global Boolean enabled;
    global String name;
    global ProfileUserPermission() {

    }
}
global class PushNotification {
    global List<String> fieldNames;
    global String objectName;
    global PushNotification() {

    }
}
global class PushNotifications {
    global List<Framework.MetadataService.PushNotification> pushNotification;
    global PushNotifications() {

    }
}
global class Queue extends Framework.MetadataService.Metadata {
    global Boolean doesSendEmailToMembers;
    global String email;
    global String fullName;
    global String name;
    global List<Framework.MetadataService.QueueSobject> queueSobject;
    global String type;
    global Queue() {

    }
}
global class QueueSobject {
    global String sobjectType;
    global QueueSobject() {

    }
}
global class QuickAction extends Framework.MetadataService.Metadata {
    global String canvas;
    global String description;
    global List<Framework.MetadataService.FieldOverride> fieldOverrides;
    global String fullName;
    global Integer height;
    global String icon;
    global Boolean isProtected;
    global String label;
    global String page_x;
    global Framework.MetadataService.QuickActionLayout quickActionLayout;
    global String standardLabel;
    global String targetObject;
    global String targetParentField;
    global String targetRecordType;
    global String type;
    global String type_x;
    global Integer width;
    global QuickAction() {

    }
}
global class QuickActionLayout {
    global String layoutSectionStyle;
    global List<Framework.MetadataService.QuickActionLayoutColumn> quickActionLayoutColumns;
    global QuickActionLayout() {

    }
}
global class QuickActionLayoutColumn {
    global List<Framework.MetadataService.QuickActionLayoutItem> quickActionLayoutItems;
    global QuickActionLayoutColumn() {

    }
}
global class QuickActionLayoutItem {
    global Boolean emptySpace;
    global String field;
    global String uiBehavior;
    global QuickActionLayoutItem() {

    }
}
global class QuickActionList {
    global List<Framework.MetadataService.QuickActionListItem> quickActionListItems;
    global QuickActionList() {

    }
}
global class QuickActionListItem {
    global String quickActionName;
    global QuickActionListItem() {

    }
}
global class QuickActionTranslation {
    global String label;
    global String name;
    global QuickActionTranslation() {

    }
}
global class QuotasSettings {
    global Boolean showQuotas;
    global QuotasSettings() {

    }
}
global class QuoteSettings extends Framework.MetadataService.Metadata {
    global Boolean enableQuote;
    global String fullName;
    global String type;
    global QuoteSettings() {

    }
}
global class ReadAccountSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.AccountSettings> records;
    global ReadAccountSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadActionLinkGroupTemplateResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ActionLinkGroupTemplate> records;
    global ReadActionLinkGroupTemplateResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadActivitiesSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ActivitiesSettings> records;
    global ReadActivitiesSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadAddressSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.AddressSettings> records;
    global ReadAddressSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadAnalyticSnapshotResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.AnalyticSnapshot> records;
    global ReadAnalyticSnapshotResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadApexClassResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ApexClass> records;
    global ReadApexClassResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadApexComponentResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ApexComponent> records;
    global ReadApexComponentResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadApexPageResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ApexPage> records;
    global ReadApexPageResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadApexTriggerResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ApexTrigger> records;
    global ReadApexTriggerResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadAppMenuResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.AppMenu> records;
    global ReadAppMenuResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadApprovalProcessResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ApprovalProcess> records;
    global ReadApprovalProcessResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadAssignmentRuleResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.AssignmentRule> records;
    global ReadAssignmentRuleResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadAssignmentRulesResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.AssignmentRules> records;
    global ReadAssignmentRulesResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadAuraDefinitionBundleResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.AuraDefinitionBundle> records;
    global ReadAuraDefinitionBundleResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadAuthProviderResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.AuthProvider> records;
    global ReadAuthProviderResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadAutoResponseRuleResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.AutoResponseRule> records;
    global ReadAutoResponseRuleResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadAutoResponseRulesResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.AutoResponseRules> records;
    global ReadAutoResponseRulesResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadBusinessHoursEntryResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.BusinessHoursEntry> records;
    global ReadBusinessHoursEntryResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadBusinessHoursSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.BusinessHoursSettings> records;
    global ReadBusinessHoursSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadBusinessProcessResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.BusinessProcess> records;
    global ReadBusinessProcessResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCallCenterResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CallCenter> records;
    global ReadCallCenterResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCaseSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CaseSettings> records;
    global ReadCaseSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadChatterAnswersSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ChatterAnswersSettings> records;
    global ReadChatterAnswersSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCommunityResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Community> records;
    global ReadCommunityResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCompactLayoutResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CompactLayout> records;
    global ReadCompactLayoutResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCompanySettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CompanySettings> records;
    global ReadCompanySettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadConnectedAppResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ConnectedApp> records;
    global ReadConnectedAppResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadContractSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ContractSettings> records;
    global ReadContractSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCorsWhitelistOriginResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CorsWhitelistOrigin> records;
    global ReadCorsWhitelistOriginResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomApplicationComponentResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomApplicationComponent> records;
    global ReadCustomApplicationComponentResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomApplicationResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomApplication> records;
    global ReadCustomApplicationResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomDataTypeResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomDataType> records;
    global ReadCustomDataTypeResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomFieldResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomField> records;
    global ReadCustomFieldResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomLabelResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomLabel> records;
    global ReadCustomLabelResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomLabelsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomLabels> records;
    global ReadCustomLabelsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomMetadataResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomMetadata> records;
    global ReadCustomMetadataResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomObjectResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomObject> records;
    global ReadCustomObjectResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomObjectTranslationResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomObjectTranslation> records;
    global ReadCustomObjectTranslationResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomPageWebLinkResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomPageWebLink> records;
    global ReadCustomPageWebLinkResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomPermissionResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomPermission> records;
    global ReadCustomPermissionResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomSiteResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomSite> records;
    global ReadCustomSiteResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadCustomTabResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.CustomTab> records;
    global ReadCustomTabResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadDashboardFolderResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.DashboardFolder> records;
    global ReadDashboardFolderResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadDashboardResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Dashboard> records;
    global ReadDashboardResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadDataCategoryGroupResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.DataCategoryGroup> records;
    global ReadDataCategoryGroupResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadDocumentFolderResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.DocumentFolder> records;
    global ReadDocumentFolderResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadDocumentResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Document> records;
    global ReadDocumentResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadEmailFolderResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.EmailFolder> records;
    global ReadEmailFolderResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadEmailTemplateResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.EmailTemplate> records;
    global ReadEmailTemplateResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadEntitlementProcessResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.EntitlementProcess> records;
    global ReadEntitlementProcessResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadEntitlementSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.EntitlementSettings> records;
    global ReadEntitlementSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadEntitlementTemplateResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.EntitlementTemplate> records;
    global ReadEntitlementTemplateResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadEscalationRuleResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.EscalationRule> records;
    global ReadEscalationRuleResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadEscalationRulesResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.EscalationRules> records;
    global ReadEscalationRulesResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadExternalDataSourceResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ExternalDataSource> records;
    global ReadExternalDataSourceResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadFieldSetResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.FieldSet> records;
    global ReadFieldSetResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadFlexiPageResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.FlexiPage> records;
    global ReadFlexiPageResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadFlowResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Flow> records;
    global ReadFlowResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadFolderResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Folder> records;
    global ReadFolderResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadForecastingSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ForecastingSettings> records;
    global ReadForecastingSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadGroupResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Group_x> records;
    global ReadGroupResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadHomePageComponentResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.HomePageComponent> records;
    global ReadHomePageComponentResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadHomePageLayoutResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.HomePageLayout> records;
    global ReadHomePageLayoutResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadIdeasSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.IdeasSettings> records;
    global ReadIdeasSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadInstalledPackageResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.InstalledPackage> records;
    global ReadInstalledPackageResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadKnowledgeSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.KnowledgeSettings> records;
    global ReadKnowledgeSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadLayoutResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Layout> records;
    global ReadLayoutResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadLetterheadResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Letterhead> records;
    global ReadLetterheadResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadLicenseDefinitionResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.LicenseDefinition> records;
    global ReadLicenseDefinitionResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadListViewResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ListView> records;
    global ReadListViewResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadLiveAgentSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.LiveAgentSettings> records;
    global ReadLiveAgentSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadLiveChatAgentConfigResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.LiveChatAgentConfig> records;
    global ReadLiveChatAgentConfigResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadLiveChatButtonResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.LiveChatButton> records;
    global ReadLiveChatButtonResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadLiveChatDeploymentResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.LiveChatDeployment> records;
    global ReadLiveChatDeploymentResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadManagedTopicsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ManagedTopics> records;
    global ReadManagedTopicsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadMarketingActionSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.MarketingActionSettings> records;
    global ReadMarketingActionSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadMarketingResourceTypeResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.MarketingResourceType> records;
    global ReadMarketingResourceTypeResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadMatchingRuleResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.MatchingRule> records;
    global ReadMatchingRuleResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadMatchingRulesResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.MatchingRules> records;
    global ReadMatchingRulesResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadMilestoneTypeResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.MilestoneType> records;
    global ReadMilestoneTypeResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadMobileSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.MobileSettings> records;
    global ReadMobileSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadNameSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.NameSettings> records;
    global ReadNameSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadNamedCredentialResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.NamedCredential> records;
    global ReadNamedCredentialResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadNetworkResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Network> records;
    global ReadNetworkResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadOpportunitySettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.OpportunitySettings> records;
    global ReadOpportunitySettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadOrderSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.OrderSettings> records;
    global ReadOrderSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadPackageResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Package_x> records;
    global ReadPackageResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadPermissionSetResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.PermissionSet> records;
    global ReadPermissionSetResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadPersonalJourneySettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.PersonalJourneySettings> records;
    global ReadPersonalJourneySettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadPicklistValueResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.PicklistValue> records;
    global ReadPicklistValueResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadPortalResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Portal> records;
    global ReadPortalResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadPostTemplateResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.PostTemplate> records;
    global ReadPostTemplateResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadProductSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ProductSettings> records;
    global ReadProductSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadProfileResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Profile> records;
    global ReadProfileResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadQueueResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Queue> records;
    global ReadQueueResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadQuickActionResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.QuickAction> records;
    global ReadQuickActionResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadQuoteSettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.QuoteSettings> records;
    global ReadQuoteSettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadRecordTypeResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.RecordType> records;
    global ReadRecordTypeResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadRemoteSiteSettingResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.RemoteSiteSetting> records;
    global ReadRemoteSiteSettingResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadReportFolderResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ReportFolder> records;
    global ReadReportFolderResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadReportResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Report> records;
    global ReadReportResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadReportTypeResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ReportType> records;
    global ReadReportTypeResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadResult {
    global List<Framework.MetadataService.Metadata> records;
    global ReadResult() {

    }
}
global class ReadRoleOrTerritoryResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.RoleOrTerritory> records;
    global ReadRoleOrTerritoryResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadSamlSsoConfigResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.SamlSsoConfig> records;
    global ReadSamlSsoConfigResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadScontrolResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Scontrol> records;
    global ReadScontrolResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadSecuritySettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.SecuritySettings> records;
    global ReadSecuritySettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadSharingBaseRuleResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.SharingBaseRule> records;
    global ReadSharingBaseRuleResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadSharingCriteriaRuleResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.SharingCriteriaRule> records;
    global ReadSharingCriteriaRuleResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadSharingOwnerRuleResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.SharingOwnerRule> records;
    global ReadSharingOwnerRuleResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadSharingReasonResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.SharingReason> records;
    global ReadSharingReasonResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadSharingRulesResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.SharingRules> records;
    global ReadSharingRulesResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadSharingSetResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.SharingSet> records;
    global ReadSharingSetResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadSharingTerritoryRuleResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.SharingTerritoryRule> records;
    global ReadSharingTerritoryRuleResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadSiteDotComResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.SiteDotCom> records;
    global ReadSiteDotComResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadSkillResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Skill> records;
    global ReadSkillResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadStaticResourceResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.StaticResource> records;
    global ReadStaticResourceResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadSynonymDictionaryResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.SynonymDictionary> records;
    global ReadSynonymDictionaryResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadTerritory2ModelResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Territory2Model> records;
    global ReadTerritory2ModelResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadTerritory2Result implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Territory2> records;
    global ReadTerritory2Result() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadTerritory2SettingsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Territory2Settings> records;
    global ReadTerritory2SettingsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadTerritory2TypeResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Territory2Type> records;
    global ReadTerritory2TypeResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadTranslationsResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Translations> records;
    global ReadTranslationsResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadValidationRuleResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.ValidationRule> records;
    global ReadValidationRuleResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadVisualizationPluginResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.VisualizationPlugin> records;
    global ReadVisualizationPluginResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadWebLinkResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.WebLink> records;
    global ReadWebLinkResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadWorkflowActionResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.WorkflowAction> records;
    global ReadWorkflowActionResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadWorkflowAlertResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.WorkflowAlert> records;
    global ReadWorkflowAlertResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadWorkflowFieldUpdateResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.WorkflowFieldUpdate> records;
    global ReadWorkflowFieldUpdateResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadWorkflowKnowledgePublishResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.WorkflowKnowledgePublish> records;
    global ReadWorkflowKnowledgePublishResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadWorkflowOutboundMessageResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.WorkflowOutboundMessage> records;
    global ReadWorkflowOutboundMessageResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadWorkflowResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.Workflow> records;
    global ReadWorkflowResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadWorkflowRuleResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.WorkflowRule> records;
    global ReadWorkflowRuleResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadWorkflowSendResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.WorkflowSend> records;
    global ReadWorkflowSendResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadWorkflowTaskResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.WorkflowTask> records;
    global ReadWorkflowTaskResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class ReadXOrgHubResult implements Framework.MetadataService.IReadResult {
    global List<Framework.MetadataService.XOrgHub> records;
    global ReadXOrgHubResult() {

    }
    global List<Framework.MetadataService.Metadata> getRecords() {
        return null;
    }
}
global class RecordType extends Framework.MetadataService.Metadata {
    global Boolean active;
    global String businessProcess;
    global String compactLayoutAssignment;
    global String description;
    global String fullName;
    global String label;
    global List<Framework.MetadataService.RecordTypePicklistValue> picklistValues;
    global String type;
    global RecordType() {

    }
}
global class RecordTypePicklistValue {
    global String picklist;
    global List<Framework.MetadataService.PicklistValue> values;
    global RecordTypePicklistValue() {

    }
}
global class RecordTypeTranslation {
    global String label;
    global String name;
    global RecordTypeTranslation() {

    }
}
global class RelatedContent {
    global List<Framework.MetadataService.RelatedContentItem> relatedContentItems;
    global RelatedContent() {

    }
}
global class RelatedContentItem {
    global Framework.MetadataService.LayoutItem layoutItem;
    global RelatedContentItem() {

    }
}
global class RelatedList {
    global Boolean hideOnDetail;
    global String name;
    global RelatedList() {

    }
}
global class RelatedListItem {
    global List<String> customButtons;
    global List<String> excludeButtons;
    global List<String> fields;
    global String relatedList;
    global String sortField;
    global String sortOrder;
    global RelatedListItem() {

    }
}
global class RemoteSiteSetting extends Framework.MetadataService.Metadata {
    global String description;
    global Boolean disableProtocolSecurity;
    global String fullName;
    global Boolean isActive;
    global String type;
    global String url;
    global RemoteSiteSetting() {

    }
}
global class Report extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.ReportAggregate> aggregates;
    global List<Framework.MetadataService.Report> block;
    global Framework.MetadataService.ReportBlockInfo blockInfo;
    global List<Framework.MetadataService.ReportBucketField> buckets;
    global Framework.MetadataService.ReportChart chart;
    global List<Framework.MetadataService.ReportColorRange> colorRanges;
    global List<Framework.MetadataService.ReportColumn> columns;
    global List<Framework.MetadataService.ReportCrossFilter> crossFilters;
    global String currency_x;
    global List<Framework.MetadataService.ReportDataCategoryFilter> dataCategoryFilters;
    global String description;
    global String division;
    global Framework.MetadataService.ReportFilter filter;
    global String format;
    global String fullName;
    global List<Framework.MetadataService.ReportGrouping> groupingsAcross;
    global List<Framework.MetadataService.ReportGrouping> groupingsDown;
    global Framework.MetadataService.ReportHistoricalSelector historicalSelector;
    global String name;
    global List<Framework.MetadataService.ReportParam> params;
    global String reportType;
    global String roleHierarchyFilter;
    global Integer rowLimit;
    global String scope;
    global Boolean showCurrentDate;
    global Boolean showDetails;
    global String sortColumn;
    global String sortOrder;
    global String territoryHierarchyFilter;
    global Framework.MetadataService.ReportTimeFrameFilter timeFrameFilter;
    global String type;
    global String userFilter;
    global Report() {

    }
}
global class ReportAggregate {
    global String acrossGroupingContext;
    global String calculatedFormula;
    global String datatype;
    global String description;
    global String developerName;
    global String downGroupingContext;
    global Boolean isActive;
    global Boolean isCrossBlock;
    global String masterLabel;
    global String reportType;
    global Integer scale;
    global ReportAggregate() {

    }
}
global class ReportAggregateReference {
    global String aggregate;
    global ReportAggregateReference() {

    }
}
global class ReportBlockInfo {
    global List<Framework.MetadataService.ReportAggregateReference> aggregateReferences;
    global String blockId;
    global String joinTable;
    global ReportBlockInfo() {

    }
}
global class ReportBucketField {
    global String bucketType;
    global String developerName;
    global String masterLabel;
    global String nullTreatment;
    global String otherBucketLabel;
    global String sourceColumnName;
    global Boolean useOther;
    global List<Framework.MetadataService.ReportBucketFieldValue> values;
    global ReportBucketField() {

    }
}
global class ReportBucketFieldSourceValue {
    global String from_x;
    global String sourceValue;
    global String to;
    global ReportBucketFieldSourceValue() {

    }
}
global class ReportBucketFieldValue {
    global List<Framework.MetadataService.ReportBucketFieldSourceValue> sourceValues;
    global String value;
    global ReportBucketFieldValue() {

    }
}
global class ReportChart {
    global String backgroundColor1;
    global String backgroundColor2;
    global String backgroundFadeDir;
    global List<Framework.MetadataService.ChartSummary> chartSummaries;
    global String chartType;
    global Boolean enableHoverLabels;
    global Boolean expandOthers;
    global String groupingColumn;
    global String legendPosition;
    global String location;
    global String secondaryGroupingColumn;
    global Boolean showAxisLabels;
    global Boolean showPercentage;
    global Boolean showTotal;
    global Boolean showValues;
    global String size;
    global Double summaryAxisManualRangeEnd;
    global Double summaryAxisManualRangeStart;
    global String summaryAxisRange;
    global String textColor;
    global Integer textSize;
    global String title;
    global String titleColor;
    global Integer titleSize;
    global ReportChart() {

    }
}
global class ReportChartComponentLayoutItem {
    global Boolean cacheData;
    global String contextFilterableField;
    global String error;
    global Boolean hideOnError;
    global Boolean includeContext;
    global String reportName;
    global Boolean showTitle;
    global String size;
    global ReportChartComponentLayoutItem() {

    }
}
global class ReportColorRange {
    global String aggregate;
    global String columnName;
    global Double highBreakpoint;
    global String highColor;
    global Double lowBreakpoint;
    global String lowColor;
    global String midColor;
    global ReportColorRange() {

    }
}
global class ReportColumn {
    global List<String> aggregateTypes;
    global String field;
    global Boolean reverseColors;
    global Boolean showChanges;
    global ReportColumn() {

    }
}
global class ReportCrossFilter {
    global List<Framework.MetadataService.ReportFilterItem> criteriaItems;
    global String operation;
    global String primaryTableColumn;
    global String relatedTable;
    global String relatedTableJoinColumn;
    global ReportCrossFilter() {

    }
}
global class ReportDataCategoryFilter {
    global String dataCategory;
    global String dataCategoryGroup;
    global String operator;
    global ReportDataCategoryFilter() {

    }
}
global class ReportFilter {
    global String booleanFilter;
    global List<Framework.MetadataService.ReportFilterItem> criteriaItems;
    global String language;
    global ReportFilter() {

    }
}
global class ReportFilterItem {
    global String column;
    global Boolean columnToColumn;
    global String operator;
    global String snapshot;
    global String value;
    global ReportFilterItem() {

    }
}
global class ReportFolder extends Framework.MetadataService.Folder {
    global String accessType;
    global List<Framework.MetadataService.FolderShare> folderShares;
    global String fullName;
    global String name;
    global String publicFolderAccess;
    global Framework.MetadataService.SharedTo sharedTo;
    global String type;
    global ReportFolder() {

    }
}
global class ReportGrouping {
    global String aggregateType;
    global String dateGranularity;
    global String field;
    global String sortByName;
    global String sortOrder;
    global String sortType;
    global ReportGrouping() {

    }
}
global class ReportHistoricalSelector {
    global List<String> snapshot;
    global ReportHistoricalSelector() {

    }
}
global class ReportLayoutSection {
    global List<Framework.MetadataService.ReportTypeColumn> columns;
    global String masterLabel;
    global ReportLayoutSection() {

    }
}
global class ReportParam {
    global String name;
    global String value;
    global ReportParam() {

    }
}
global class ReportTimeFrameFilter {
    global String dateColumn;
    global Date endDate;
    global String interval;
    global Date startDate;
    global ReportTimeFrameFilter() {

    }
}
global class ReportType extends Framework.MetadataService.Metadata {
    global Boolean autogenerated;
    global String baseObject;
    global String category;
    global Boolean deployed;
    global String description;
    global String fullName;
    global Framework.MetadataService.ObjectRelationship join_x;
    global String label;
    global List<Framework.MetadataService.ReportLayoutSection> sections;
    global String type;
    global ReportType() {

    }
}
global class ReportTypeColumn {
    global Boolean checkedByDefault;
    global String displayNameOverride;
    global String field;
    global String table;
    global ReportTypeColumn() {

    }
}
global class ReportTypeColumnTranslation {
    global String label;
    global String name;
    global ReportTypeColumnTranslation() {

    }
}
global class ReportTypeSectionTranslation {
    global List<Framework.MetadataService.ReportTypeColumnTranslation> columns;
    global String label;
    global String name;
    global ReportTypeSectionTranslation() {

    }
}
global class ReportTypeTranslation {
    global String description;
    global String label;
    global String name;
    global List<Framework.MetadataService.ReportTypeSectionTranslation> sections;
    global ReportTypeTranslation() {

    }
}
global class ReputationBranding {
    global String smallImage;
    global ReputationBranding() {

    }
}
global class ReputationLevel {
    global Framework.MetadataService.ReputationBranding branding;
    global String label;
    global Double lowerThreshold;
    global ReputationLevel() {

    }
}
global class ReputationLevelDefinitions {
    global List<Framework.MetadataService.ReputationLevel> level;
    global ReputationLevelDefinitions() {

    }
}
global class ReputationLevels {
    global List<Framework.MetadataService.ChatterAnswersReputationLevel> chatterAnswersReputationLevels;
    global List<Framework.MetadataService.IdeaReputationLevel> ideaReputationLevels;
    global ReputationLevels() {

    }
}
global class ReputationPointsRule {
    global String eventType;
    global Integer points;
    global ReputationPointsRule() {

    }
}
global class ReputationPointsRules {
    global List<Framework.MetadataService.ReputationPointsRule> pointsRule;
    global ReputationPointsRules() {

    }
}
global class RetrieveMessage {
    global String fileName;
    global String problem;
    global RetrieveMessage() {

    }
}
global class RetrieveRequest {
    global Double apiVersion;
    global List<String> packageNames;
    global Boolean singlePackage;
    global List<String> specificFiles;
    global Framework.MetadataService.Package_x unpackaged;
    global RetrieveRequest() {

    }
}
global class RetrieveResult {
    global Boolean done;
    global String errorMessage;
    global String errorStatusCode;
    global List<Framework.MetadataService.FileProperties> fileProperties;
    global String id;
    global List<Framework.MetadataService.RetrieveMessage> messages;
    global String status;
    global Boolean success;
    global String zipFile;
    global RetrieveResult() {

    }
}
global class Role {
    global String parentRole;
    global Role() {

    }
}
global class RoleOrTerritory extends Framework.MetadataService.Metadata {
    global String caseAccessLevel;
    global String contactAccessLevel;
    global String description;
    global String fullName;
    global Boolean mayForecastManagerShare;
    global String name;
    global String opportunityAccessLevel;
    global String type;
    global RoleOrTerritory() {

    }
}
global class RuleEntry {
    global String assignedTo;
    global String assignedToType;
    global String booleanFilter;
    global String businessHours;
    global String businessHoursSource;
    global List<Framework.MetadataService.FilterItem> criteriaItems;
    global Boolean disableEscalationWhenModified;
    global List<Framework.MetadataService.EscalationAction> escalationAction;
    global String escalationStartTime;
    global String formula;
    global Boolean notifyCcRecipients;
    global Boolean overrideExistingTeams;
    global String replyToEmail;
    global String senderEmail;
    global String senderName;
    global List<String> team;
    global String template;
    global RuleEntry() {

    }
}
global class RunTestFailure {
    global String id;
    global String message;
    global String methodName;
    global String name;
    global String namespace;
    global String packageName;
    global Boolean seeAllData;
    global String stackTrace;
    global Double time_x;
    global String type_x;
    global RunTestFailure() {

    }
}
global class RunTestSuccess {
    global String id;
    global String methodName;
    global String name;
    global String namespace;
    global Boolean seeAllData;
    global Double time_x;
    global RunTestSuccess() {

    }
}
global class RunTestsResult {
    global List<Framework.MetadataService.CodeCoverageResult> codeCoverage;
    global List<Framework.MetadataService.CodeCoverageWarning> codeCoverageWarnings;
    global List<Framework.MetadataService.RunTestFailure> failures;
    global Integer numFailures;
    global Integer numTestsRun;
    global List<Framework.MetadataService.RunTestSuccess> successes;
    global Double totalTime;
    global RunTestsResult() {

    }
}
global class SFDCMobileSettings {
    global Boolean enableMobileLite;
    global Boolean enableUserToDeviceLinking;
    global SFDCMobileSettings() {

    }
}
global class SamlSsoConfig extends Framework.MetadataService.Metadata {
    global String attributeName;
    global String attributeNameIdFormat;
    global String decryptionCertificate;
    global String errorUrl;
    global String executionUserId;
    global String fullName;
    global String identityLocation;
    global String identityMapping;
    global String issuer;
    global String loginUrl;
    global String logoutUrl;
    global String name;
    global String oauthTokenEndpoint;
    global Boolean redirectBinding;
    global String requestSignatureMethod;
    global String salesforceLoginUrl;
    global String samlEntityId;
    global String samlJitHandlerId;
    global String samlVersion;
    global String type;
    global Boolean userProvisioning;
    global String validationCert;
    global SamlSsoConfig() {

    }
}
global class SaveResult {
    global List<Framework.MetadataService.Error> errors;
    global String fullName;
    global Boolean success;
    global SaveResult() {

    }
}
global class Scontrol extends Framework.MetadataService.MetadataWithContent {
    global String content;
    global String contentSource;
    global String description;
    global String encodingKey;
    global String fileContent;
    global String fileName;
    global String fullName;
    global String name;
    global Boolean supportsCaching;
    global String type;
    global Scontrol() {

    }
}
global class ScontrolTranslation {
    global String label;
    global String name;
    global ScontrolTranslation() {

    }
}
global class SearchLayouts {
    global List<String> customTabListAdditionalFields;
    global List<String> excludedStandardButtons;
    global List<String> listViewButtons;
    global List<String> lookupDialogsAdditionalFields;
    global List<String> lookupFilterFields;
    global List<String> lookupPhoneDialogsAdditionalFields;
    global List<String> searchFilterFields;
    global List<String> searchResultsAdditionalFields;
    global List<String> searchResultsCustomButtons;
    global SearchLayouts() {

    }
}
global class SecuritySettings extends Framework.MetadataService.Metadata {
    global String fullName;
    global Framework.MetadataService.NetworkAccess networkAccess;
    global Framework.MetadataService.PasswordPolicies passwordPolicies;
    global Framework.MetadataService.SessionSettings sessionSettings;
    global String type;
    global SecuritySettings() {

    }
}
global class SessionHeader_element {
    global String sessionId;
    global SessionHeader_element() {

    }
}
global class SessionSettings {
    global Boolean disableTimeoutWarning;
    global Boolean enableCacheAndAutocomplete;
    global Boolean enableClickjackNonsetupSFDC;
    global Boolean enableClickjackNonsetupUser;
    global Boolean enableClickjackSetup;
    global Boolean enableCSRFOnGet;
    global Boolean enableCSRFOnPost;
    global Boolean enablePostForSessions;
    global Boolean enableSMSIdentity;
    global Boolean forceLogoutOnSessionTimeout;
    global Boolean forceRelogin;
    global Boolean lockSessionsToDomain;
    global Boolean lockSessionsToIp;
    global String sessionTimeout;
    global SessionSettings() {

    }
}
global class SharedTo {
    global String allCustomerPortalUsers;
    global String allInternalUsers;
    global String allPartnerUsers;
    global List<String> group_x;
    global List<String> groups;
    global List<String> managers;
    global List<String> managerSubordinates;
    global List<String> portalRole;
    global List<String> portalRoleAndSubordinates;
    global List<String> queue;
    global List<String> role;
    global List<String> roleAndSubordinates;
    global List<String> roleAndSubordinatesInternal;
    global List<String> roles;
    global List<String> rolesAndSubordinates;
    global List<String> territories;
    global List<String> territoriesAndSubordinates;
    global List<String> territory;
    global List<String> territoryAndSubordinates;
    global SharedTo() {

    }
}
global virtual class SharingBaseRule extends Framework.MetadataService.Metadata {
    global String accessLevel;
    global Framework.MetadataService.AccountSharingRuleSettings accountSettings;
    global String description;
    global String fullName;
    global String label;
    global Framework.MetadataService.SharedTo sharedTo;
    global String type;
    global SharingBaseRule() {

    }
}
global class SharingCriteriaRule extends Framework.MetadataService.SharingBaseRule {
    global String accessLevel;
    global Framework.MetadataService.AccountSharingRuleSettings accountSettings;
    global String booleanFilter;
    global List<Framework.MetadataService.FilterItem> criteriaItems;
    global String description;
    global String fullName;
    global String label;
    global Framework.MetadataService.SharedTo sharedTo;
    global String type;
    global SharingCriteriaRule() {

    }
}
global class SharingOwnerRule extends Framework.MetadataService.SharingBaseRule {
    global String accessLevel;
    global Framework.MetadataService.AccountSharingRuleSettings accountSettings;
    global String description;
    global String fullName;
    global String label;
    global Framework.MetadataService.SharedTo sharedFrom;
    global Framework.MetadataService.SharedTo sharedTo;
    global String type;
    global SharingOwnerRule() {

    }
}
global class SharingReason extends Framework.MetadataService.Metadata {
    global String fullName;
    global String label;
    global String type;
    global SharingReason() {

    }
}
global class SharingReasonTranslation {
    global String label;
    global String name;
    global SharingReasonTranslation() {

    }
}
global class SharingRecalculation {
    global String className;
    global SharingRecalculation() {

    }
}
global class SharingRules extends Framework.MetadataService.Metadata {
    global String fullName;
    global List<Framework.MetadataService.SharingCriteriaRule> sharingCriteriaRules;
    global List<Framework.MetadataService.SharingOwnerRule> sharingOwnerRules;
    global List<Framework.MetadataService.SharingTerritoryRule> sharingTerritoryRules;
    global String type;
    global SharingRules() {

    }
}
global class SharingSet extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.AccessMapping> accessMappings;
    global String description;
    global String fullName;
    global String name;
    global List<String> profiles;
    global String type;
    global SharingSet() {

    }
}
global class SharingTerritoryRule extends Framework.MetadataService.SharingBaseRule {
    global String accessLevel;
    global Framework.MetadataService.AccountSharingRuleSettings accountSettings;
    global String description;
    global String fullName;
    global String label;
    global Framework.MetadataService.SharedTo sharedTo;
    global String type;
    global SharingTerritoryRule() {

    }
}
global class SidebarComponent {
    global String componentType;
    global Integer height;
    global String label;
    global String lookup;
    global String page_x;
    global List<Framework.MetadataService.RelatedList> relatedLists;
    global String unit;
    global Integer width;
    global SidebarComponent() {

    }
}
global class SiteDotCom extends Framework.MetadataService.MetadataWithContent {
    global String content;
    global String fullName;
    global String label;
    global String siteType;
    global String type;
    global SiteDotCom() {

    }
}
global class SiteRedirectMapping {
    global String action;
    global Boolean isActive;
    global String source;
    global String target;
    global SiteRedirectMapping() {

    }
}
global class SiteWebAddress {
    global String certificate;
    global String domainName;
    global Boolean primary;
    global SiteWebAddress() {

    }
}
global class Skill extends Framework.MetadataService.Metadata {
    global Framework.MetadataService.SkillAssignments assignments;
    global String fullName;
    global String label;
    global String type;
    global Skill() {

    }
}
global class SkillAssignments {
    global Framework.MetadataService.SkillProfileAssignments profiles;
    global Framework.MetadataService.SkillUserAssignments users;
    global SkillAssignments() {

    }
}
global class SkillProfileAssignments {
    global List<String> profile;
    global SkillProfileAssignments() {

    }
}
global class SkillUserAssignments {
    global List<String> user_x;
    global SkillUserAssignments() {

    }
}
global class StandardFieldTranslation {
    global String label;
    global String name;
    global StandardFieldTranslation() {

    }
}
global class State {
    global Boolean active;
    global String integrationValue;
    global String isoCode;
    global String label;
    global Boolean standard;
    global Boolean visible;
    global State() {

    }
}
global class StaticResource extends Framework.MetadataService.MetadataWithContent {
    global String cacheControl;
    global String content;
    global String contentType;
    global String description;
    global String fullName;
    global String type;
    global StaticResource() {

    }
}
global class SubtabComponents {
    global List<Framework.MetadataService.Container> containers;
    global SubtabComponents() {

    }
}
global class SummaryLayout {
    global String masterLabel;
    global Integer sizeX;
    global Integer sizeY;
    global Integer sizeZ;
    global List<Framework.MetadataService.SummaryLayoutItem> summaryLayoutItems;
    global String summaryLayoutStyle;
    global SummaryLayout() {

    }
}
global class SummaryLayoutItem {
    global String customLink;
    global String field;
    global Integer posX;
    global Integer posY;
    global Integer posZ;
    global SummaryLayoutItem() {

    }
}
global class SupervisorAgentConfigSkills {
    global List<String> skill;
    global SupervisorAgentConfigSkills() {

    }
}
global class SynonymDictionary extends Framework.MetadataService.Metadata {
    global String fullName;
    global List<Framework.MetadataService.SynonymGroup> groups;
    global Boolean isProtected;
    global String label;
    global String type;
    global SynonymDictionary() {

    }
}
global class SynonymGroup {
    global List<String> languages;
    global List<String> terms;
    global SynonymGroup() {

    }
}
global class Territory {
    global String accountAccessLevel;
    global String parentTerritory;
    global Territory() {

    }
}
global class Territory2 extends Framework.MetadataService.Metadata {
    global String accountAccessLevel;
    global String caseAccessLevel;
    global String contactAccessLevel;
    global List<Framework.MetadataService.FieldValue> customFields;
    global String description;
    global String fullName;
    global String name;
    global String opportunityAccessLevel;
    global String parentTerritory;
    global List<Framework.MetadataService.Territory2RuleAssociation> ruleAssociations;
    global String territory2Type;
    global String type;
    global Territory2() {

    }
}
global class Territory2Model extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.FieldValue> customFields;
    global String description;
    global String fullName;
    global String name;
    global String type;
    global Territory2Model() {

    }
}
global class Territory2Rule {
    global Boolean active;
    global String booleanFilter;
    global String name;
    global String objectType;
    global List<Framework.MetadataService.Territory2RuleItem> ruleItems;
    global Territory2Rule() {

    }
}
global class Territory2RuleAssociation {
    global Boolean inherited;
    global String ruleName;
    global Territory2RuleAssociation() {

    }
}
global class Territory2RuleItem {
    global String field;
    global String operation;
    global String value;
    global Territory2RuleItem() {

    }
}
global class Territory2Settings extends Framework.MetadataService.Metadata {
    global String defaultAccountAccessLevel;
    global String defaultCaseAccessLevel;
    global String defaultContactAccessLevel;
    global String defaultOpportunityAccessLevel;
    global String fullName;
    global String type;
    global Territory2Settings() {

    }
}
global class Territory2Type extends Framework.MetadataService.Metadata {
    global String description;
    global String fullName;
    global String name;
    global Integer priority;
    global String type;
    global Territory2Type() {

    }
}
global class TouchMobileSettings {
    global Boolean enableTouchAppIPad;
    global Boolean enableTouchAppIPhone;
    global Boolean enableTouchBrowserIPad;
    global Boolean enableTouchIosPhone;
    global Boolean enableVisualforceInTouch;
    global TouchMobileSettings() {

    }
}
global class Translations extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.CustomApplicationTranslation> customApplications;
    global List<Framework.MetadataService.CustomDataTypeTranslation> customDataTypeTranslations;
    global List<Framework.MetadataService.CustomLabelTranslation> customLabels;
    global List<Framework.MetadataService.CustomPageWebLinkTranslation> customPageWebLinks;
    global List<Framework.MetadataService.CustomTabTranslation> customTabs;
    global String fullName;
    global List<Framework.MetadataService.GlobalQuickActionTranslation> quickActions;
    global List<Framework.MetadataService.ReportTypeTranslation> reportTypes;
    global List<Framework.MetadataService.ScontrolTranslation> scontrols;
    global String type;
    global Translations() {

    }
}
global class UiPlugin {
    global String description;
    global String extensionPointIdentifier;
    global Boolean isEnabled;
    global String language;
    global String masterLabel;
    global UiPlugin() {

    }
}
global class UpsertResult {
    global Boolean created;
    global List<Framework.MetadataService.Error> errors;
    global String fullName;
    global Boolean success;
    global UpsertResult() {

    }
}
global class ValidationRule extends Framework.MetadataService.Metadata {
    global Boolean active;
    global String description;
    global String errorConditionFormula;
    global String errorDisplayField;
    global String errorMessage;
    global String fullName;
    global String type;
    global ValidationRule() {

    }
}
global class ValidationRuleTranslation {
    global String errorMessage;
    global String name;
    global ValidationRuleTranslation() {

    }
}
global class ValueTypeField {
    global List<Framework.MetadataService.ValueTypeField> fields;
    global List<String> foreignKeyDomain;
    global Boolean isForeignKey;
    global Boolean isNameField;
    global Integer minOccurs;
    global String name;
    global List<Framework.MetadataService.PicklistEntry> picklistValues;
    global String soapType;
    global ValueTypeField() {

    }
}
global class VisualizationPlugin extends Framework.MetadataService.Metadata {
    global String description;
    global String developerName;
    global String fullName;
    global String icon;
    global String masterLabel;
    global String type;
    global List<Framework.MetadataService.VisualizationResource> visualizationResources;
    global List<Framework.MetadataService.VisualizationType> visualizationTypes;
    global VisualizationPlugin() {

    }
}
global class VisualizationResource {
    global String description;
    global String file;
    global Integer rank;
    global String type_x;
    global VisualizationResource() {

    }
}
global class VisualizationType {
    global String description;
    global String developerName;
    global String icon;
    global String masterLabel;
    global String scriptBootstrapMethod;
    global VisualizationType() {

    }
}
global class WebLink extends Framework.MetadataService.Metadata {
    global String availability;
    global String description;
    global String displayType;
    global String encodingKey;
    global String fullName;
    global Boolean hasMenubar;
    global Boolean hasScrollbars;
    global Boolean hasToolbar;
    global Integer height;
    global Boolean isResizable;
    global String linkType;
    global String masterLabel;
    global String openType;
    global String page_x;
    global String position;
    global Boolean protected_x;
    global Boolean requireRowSelection;
    global String scontrol;
    global Boolean showsLocation;
    global Boolean showsStatus;
    global String type;
    global String url;
    global Integer width;
    global WebLink() {

    }
}
global class WebLinkTranslation {
    global String label;
    global String name;
    global WebLinkTranslation() {

    }
}
global class WebToCaseSettings {
    global String caseOrigin;
    global String defaultResponseTemplate;
    global Boolean enableWebToCase;
    global WebToCaseSettings() {

    }
}
global class Workflow extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.WorkflowAlert> alerts;
    global List<Framework.MetadataService.WorkflowFieldUpdate> fieldUpdates;
    global List<Framework.MetadataService.WorkflowFlowAction> flowActions;
    global String fullName;
    global List<Framework.MetadataService.WorkflowKnowledgePublish> knowledgePublishes;
    global List<Framework.MetadataService.WorkflowOutboundMessage> outboundMessages;
    global List<Framework.MetadataService.WorkflowRule> rules;
    global List<Framework.MetadataService.WorkflowSend> send;
    global List<Framework.MetadataService.WorkflowTask> tasks;
    global String type;
    global Workflow() {

    }
}
global virtual class WorkflowAction extends Framework.MetadataService.Metadata {
    global WorkflowAction() {

    }
}
global class WorkflowActionReference {
    global String name;
    global String type_x;
    global WorkflowActionReference() {

    }
}
global class WorkflowAlert extends Framework.MetadataService.WorkflowAction {
    global List<String> ccEmails;
    global String description;
    global String fullName;
    global Boolean protected_x;
    global List<Framework.MetadataService.WorkflowEmailRecipient> recipients;
    global String senderAddress;
    global String senderType;
    global String template;
    global String type;
    global WorkflowAlert() {

    }
}
global class WorkflowEmailRecipient {
    global String field;
    global String recipient;
    global String type_x;
    global WorkflowEmailRecipient() {

    }
}
global class WorkflowFieldUpdate extends Framework.MetadataService.WorkflowAction {
    global String description;
    global String field;
    global String formula;
    global String fullName;
    global String literalValue;
    global String lookupValue;
    global String lookupValueType;
    global String name;
    global Boolean notifyAssignee;
    global String operation;
    global Boolean protected_x;
    global Boolean reevaluateOnChange;
    global String targetObject;
    global String type;
    global WorkflowFieldUpdate() {

    }
}
global class WorkflowFlowAction {
    global String description;
    global String flow;
    global List<Framework.MetadataService.WorkflowFlowActionParameter> flowInputs;
    global String label;
    global String language;
    global Boolean protected_x;
    global WorkflowFlowAction() {

    }
}
global class WorkflowFlowActionParameter {
    global String name;
    global String value;
    global WorkflowFlowActionParameter() {

    }
}
global class WorkflowKnowledgePublish extends Framework.MetadataService.WorkflowAction {
    global String action;
    global String description;
    global String fullName;
    global String label;
    global String language;
    global Boolean protected_x;
    global String type;
    global WorkflowKnowledgePublish() {

    }
}
global class WorkflowOutboundMessage extends Framework.MetadataService.WorkflowAction {
    global Double apiVersion;
    global String description;
    global String endpointUrl;
    global List<String> fields;
    global String fullName;
    global Boolean includeSessionId;
    global String integrationUser;
    global String name;
    global Boolean protected_x;
    global String type;
    global Boolean useDeadLetterQueue;
    global WorkflowOutboundMessage() {

    }
}
global class WorkflowRule extends Framework.MetadataService.Metadata {
    global List<Framework.MetadataService.WorkflowActionReference> actions;
    global Boolean active;
    global String booleanFilter;
    global List<Framework.MetadataService.FilterItem> criteriaItems;
    global String description;
    global String formula;
    global String fullName;
    global String triggerType;
    global String type;
    global List<Framework.MetadataService.WorkflowTimeTrigger> workflowTimeTriggers;
    global WorkflowRule() {

    }
}
global class WorkflowSend extends Framework.MetadataService.WorkflowAction {
    global String action;
    global String description;
    global String fullName;
    global String label;
    global String language;
    global Boolean protected_x;
    global String type;
    global WorkflowSend() {

    }
}
global class WorkflowTask extends Framework.MetadataService.WorkflowAction {
    global String assignedTo;
    global String assignedToType;
    global String description;
    global Integer dueDateOffset;
    global String fullName;
    global Boolean notifyAssignee;
    global String offsetFromField;
    global String priority;
    global Boolean protected_x;
    global String status;
    global String subject;
    global String type;
    global WorkflowTask() {

    }
}
global class WorkflowTaskTranslation {
    global String description;
    global String name;
    global String subject;
    global WorkflowTaskTranslation() {

    }
}
global class WorkflowTimeTrigger {
    global List<Framework.MetadataService.WorkflowActionReference> actions;
    global String offsetFromField;
    global String timeLength;
    global String workflowTimeTriggerUnit;
    global WorkflowTimeTrigger() {

    }
}
global class WorkspaceMapping {
    global String fieldName;
    global String tab;
    global WorkspaceMapping() {

    }
}
global class WorkspaceMappings {
    global List<Framework.MetadataService.WorkspaceMapping> mapping;
    global WorkspaceMappings() {

    }
}
global class XOrgHub extends Framework.MetadataService.Metadata {
    global String fullName;
    global String label;
    global Boolean lockSharedObjects;
    global List<String> permissionSets;
    global List<Framework.MetadataService.XOrgHubSharedObject> sharedObjects;
    global String type;
    global XOrgHub() {

    }
}
global class XOrgHubSharedObject {
    global List<String> fields;
    global String name;
    global XOrgHubSharedObject() {

    }
}
global class cancelDeployResponse_element {
    global Framework.MetadataService.CancelDeployResult result;
    global cancelDeployResponse_element() {

    }
}
global class cancelDeploy_element {
    global String String_x;
    global cancelDeploy_element() {

    }
}
global class checkDeployStatusResponse_element {
    global Framework.MetadataService.DeployResult result;
    global checkDeployStatusResponse_element() {

    }
}
global class checkDeployStatus_element {
    global String asyncProcessId;
    global Boolean includeDetails;
    global checkDeployStatus_element() {

    }
}
global class checkRetrieveStatusResponse_element {
    global Framework.MetadataService.RetrieveResult result;
    global checkRetrieveStatusResponse_element() {

    }
}
global class checkRetrieveStatus_element {
    global String asyncProcessId;
    global checkRetrieveStatus_element() {

    }
}
global class createMetadataResponse_element {
    global List<Framework.MetadataService.SaveResult> result;
    global createMetadataResponse_element() {

    }
}
global class createMetadata_element {
    global List<Framework.MetadataService.Metadata> metadata;
    global createMetadata_element() {

    }
}
global class deleteMetadataResponse_element {
    global List<Framework.MetadataService.DeleteResult> result;
    global deleteMetadataResponse_element() {

    }
}
global class deleteMetadata_element {
    global List<String> fullNames;
    global String type_x;
    global deleteMetadata_element() {

    }
}
global class deployRecentValidationResponse_element {
    global String result;
    global deployRecentValidationResponse_element() {

    }
}
global class deployRecentValidation_element {
    global String validationId;
    global deployRecentValidation_element() {

    }
}
global class deployResponse_element {
    global Framework.MetadataService.AsyncResult result;
    global deployResponse_element() {

    }
}
global class deploy_element {
    global Framework.MetadataService.DeployOptions DeployOptions;
    global String ZipFile;
    global deploy_element() {

    }
}
global class describeMetadataResponse_element {
    global Framework.MetadataService.DescribeMetadataResult result;
    global describeMetadataResponse_element() {

    }
}
global class describeMetadata_element {
    global Double asOfVersion;
    global describeMetadata_element() {

    }
}
global class describeValueTypeResponse_element {
    global Framework.MetadataService.DescribeValueTypeResult result;
    global describeValueTypeResponse_element() {

    }
}
global class describeValueType_element {
    global String type_x;
    global describeValueType_element() {

    }
}
global class listMetadataResponse_element {
    global List<Framework.MetadataService.FileProperties> result;
    global listMetadataResponse_element() {

    }
}
global class listMetadata_element {
    global Double asOfVersion;
    global List<Framework.MetadataService.ListMetadataQuery> queries;
    global listMetadata_element() {

    }
}
global class readAccountSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadAccountSettingsResult result;
    global readAccountSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readActionLinkGroupTemplateResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadActionLinkGroupTemplateResult result;
    global readActionLinkGroupTemplateResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readActivitiesSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadActivitiesSettingsResult result;
    global readActivitiesSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readAddressSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadAddressSettingsResult result;
    global readAddressSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readAnalyticSnapshotResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadAnalyticSnapshotResult result;
    global readAnalyticSnapshotResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readApexClassResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadApexClassResult result;
    global readApexClassResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readApexComponentResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadApexComponentResult result;
    global readApexComponentResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readApexPageResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadApexPageResult result;
    global readApexPageResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readApexTriggerResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadApexTriggerResult result;
    global readApexTriggerResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readAppMenuResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadAppMenuResult result;
    global readAppMenuResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readApprovalProcessResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadApprovalProcessResult result;
    global readApprovalProcessResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readAssignmentRuleResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadAssignmentRuleResult result;
    global readAssignmentRuleResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readAssignmentRulesResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadAssignmentRulesResult result;
    global readAssignmentRulesResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readAuraDefinitionBundleResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadAuraDefinitionBundleResult result;
    global readAuraDefinitionBundleResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readAuthProviderResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadAuthProviderResult result;
    global readAuthProviderResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readAutoResponseRuleResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadAutoResponseRuleResult result;
    global readAutoResponseRuleResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readAutoResponseRulesResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadAutoResponseRulesResult result;
    global readAutoResponseRulesResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readBusinessHoursEntryResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadBusinessHoursEntryResult result;
    global readBusinessHoursEntryResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readBusinessHoursSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadBusinessHoursSettingsResult result;
    global readBusinessHoursSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readBusinessProcessResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadBusinessProcessResult result;
    global readBusinessProcessResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCallCenterResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCallCenterResult result;
    global readCallCenterResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCaseSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCaseSettingsResult result;
    global readCaseSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readChatterAnswersSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadChatterAnswersSettingsResult result;
    global readChatterAnswersSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCommunityResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCommunityResult result;
    global readCommunityResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCompactLayoutResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCompactLayoutResult result;
    global readCompactLayoutResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCompanySettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCompanySettingsResult result;
    global readCompanySettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readConnectedAppResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadConnectedAppResult result;
    global readConnectedAppResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readContractSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadContractSettingsResult result;
    global readContractSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCorsWhitelistOriginResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCorsWhitelistOriginResult result;
    global readCorsWhitelistOriginResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomApplicationComponentResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomApplicationComponentResult result;
    global readCustomApplicationComponentResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomApplicationResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomApplicationResult result;
    global readCustomApplicationResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomDataTypeResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomDataTypeResult result;
    global readCustomDataTypeResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomFieldResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomFieldResult result;
    global readCustomFieldResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomLabelResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomLabelResult result;
    global readCustomLabelResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomLabelsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomLabelsResult result;
    global readCustomLabelsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomMetadataResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomMetadataResult result;
    global readCustomMetadataResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomObjectResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomObjectResult result;
    global readCustomObjectResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomObjectTranslationResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomObjectTranslationResult result;
    global readCustomObjectTranslationResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomPageWebLinkResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomPageWebLinkResult result;
    global readCustomPageWebLinkResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomPermissionResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomPermissionResult result;
    global readCustomPermissionResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomSiteResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomSiteResult result;
    global readCustomSiteResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readCustomTabResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadCustomTabResult result;
    global readCustomTabResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readDashboardFolderResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadDashboardFolderResult result;
    global readDashboardFolderResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readDashboardResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadDashboardResult result;
    global readDashboardResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readDataCategoryGroupResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadDataCategoryGroupResult result;
    global readDataCategoryGroupResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readDocumentFolderResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadDocumentFolderResult result;
    global readDocumentFolderResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readDocumentResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadDocumentResult result;
    global readDocumentResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readEmailFolderResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadEmailFolderResult result;
    global readEmailFolderResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readEmailTemplateResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadEmailTemplateResult result;
    global readEmailTemplateResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readEntitlementProcessResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadEntitlementProcessResult result;
    global readEntitlementProcessResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readEntitlementSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadEntitlementSettingsResult result;
    global readEntitlementSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readEntitlementTemplateResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadEntitlementTemplateResult result;
    global readEntitlementTemplateResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readEscalationRuleResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadEscalationRuleResult result;
    global readEscalationRuleResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readEscalationRulesResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadEscalationRulesResult result;
    global readEscalationRulesResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readExternalDataSourceResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadExternalDataSourceResult result;
    global readExternalDataSourceResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readFieldSetResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadFieldSetResult result;
    global readFieldSetResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readFlexiPageResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadFlexiPageResult result;
    global readFlexiPageResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readFlowResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadFlowResult result;
    global readFlowResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readFolderResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadFolderResult result;
    global readFolderResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readForecastingSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadForecastingSettingsResult result;
    global readForecastingSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readGroupResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadGroupResult result;
    global readGroupResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readHomePageComponentResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadHomePageComponentResult result;
    global readHomePageComponentResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readHomePageLayoutResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadHomePageLayoutResult result;
    global readHomePageLayoutResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readIdeasSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadIdeasSettingsResult result;
    global readIdeasSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readInstalledPackageResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadInstalledPackageResult result;
    global readInstalledPackageResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readKnowledgeSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadKnowledgeSettingsResult result;
    global readKnowledgeSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readLayoutResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadLayoutResult result;
    global readLayoutResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readLetterheadResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadLetterheadResult result;
    global readLetterheadResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readLicenseDefinitionResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadLicenseDefinitionResult result;
    global readLicenseDefinitionResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readListViewResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadListViewResult result;
    global readListViewResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readLiveAgentSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadLiveAgentSettingsResult result;
    global readLiveAgentSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readLiveChatAgentConfigResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadLiveChatAgentConfigResult result;
    global readLiveChatAgentConfigResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readLiveChatButtonResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadLiveChatButtonResult result;
    global readLiveChatButtonResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readLiveChatDeploymentResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadLiveChatDeploymentResult result;
    global readLiveChatDeploymentResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readManagedTopicsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadManagedTopicsResult result;
    global readManagedTopicsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readMarketingActionSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadMarketingActionSettingsResult result;
    global readMarketingActionSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readMarketingResourceTypeResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadMarketingResourceTypeResult result;
    global readMarketingResourceTypeResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readMatchingRuleResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadMatchingRuleResult result;
    global readMatchingRuleResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readMatchingRulesResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadMatchingRulesResult result;
    global readMatchingRulesResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readMetadataResponse_element {
    global Framework.MetadataService.ReadResult result;
    global readMetadataResponse_element() {

    }
}
global class readMetadata_element {
    global List<String> fullNames;
    global String type_x;
    global readMetadata_element() {

    }
}
global class readMilestoneTypeResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadMilestoneTypeResult result;
    global readMilestoneTypeResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readMobileSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadMobileSettingsResult result;
    global readMobileSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readNameSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadNameSettingsResult result;
    global readNameSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readNamedCredentialResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadNamedCredentialResult result;
    global readNamedCredentialResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readNetworkResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadNetworkResult result;
    global readNetworkResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readOpportunitySettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadOpportunitySettingsResult result;
    global readOpportunitySettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readOrderSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadOrderSettingsResult result;
    global readOrderSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readPackageResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadPackageResult result;
    global readPackageResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readPermissionSetResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadPermissionSetResult result;
    global readPermissionSetResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readPersonalJourneySettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadPersonalJourneySettingsResult result;
    global readPersonalJourneySettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readPicklistValueResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadPicklistValueResult result;
    global readPicklistValueResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readPortalResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadPortalResult result;
    global readPortalResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readPostTemplateResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadPostTemplateResult result;
    global readPostTemplateResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readProductSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadProductSettingsResult result;
    global readProductSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readProfileResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadProfileResult result;
    global readProfileResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readQueueResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadQueueResult result;
    global readQueueResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readQuickActionResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadQuickActionResult result;
    global readQuickActionResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readQuoteSettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadQuoteSettingsResult result;
    global readQuoteSettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readRecordTypeResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadRecordTypeResult result;
    global readRecordTypeResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readRemoteSiteSettingResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadRemoteSiteSettingResult result;
    global readRemoteSiteSettingResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readReportFolderResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadReportFolderResult result;
    global readReportFolderResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readReportResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadReportResult result;
    global readReportResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readReportTypeResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadReportTypeResult result;
    global readReportTypeResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readRoleOrTerritoryResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadRoleOrTerritoryResult result;
    global readRoleOrTerritoryResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readSamlSsoConfigResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadSamlSsoConfigResult result;
    global readSamlSsoConfigResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readScontrolResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadScontrolResult result;
    global readScontrolResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readSecuritySettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadSecuritySettingsResult result;
    global readSecuritySettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readSharingBaseRuleResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadSharingBaseRuleResult result;
    global readSharingBaseRuleResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readSharingCriteriaRuleResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadSharingCriteriaRuleResult result;
    global readSharingCriteriaRuleResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readSharingOwnerRuleResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadSharingOwnerRuleResult result;
    global readSharingOwnerRuleResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readSharingReasonResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadSharingReasonResult result;
    global readSharingReasonResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readSharingRulesResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadSharingRulesResult result;
    global readSharingRulesResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readSharingSetResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadSharingSetResult result;
    global readSharingSetResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readSharingTerritoryRuleResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadSharingTerritoryRuleResult result;
    global readSharingTerritoryRuleResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readSiteDotComResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadSiteDotComResult result;
    global readSiteDotComResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readSkillResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadSkillResult result;
    global readSkillResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readStaticResourceResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadStaticResourceResult result;
    global readStaticResourceResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readSynonymDictionaryResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadSynonymDictionaryResult result;
    global readSynonymDictionaryResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readTerritory2ModelResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadTerritory2ModelResult result;
    global readTerritory2ModelResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readTerritory2Response_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadTerritory2Result result;
    global readTerritory2Response_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readTerritory2SettingsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadTerritory2SettingsResult result;
    global readTerritory2SettingsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readTerritory2TypeResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadTerritory2TypeResult result;
    global readTerritory2TypeResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readTranslationsResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadTranslationsResult result;
    global readTranslationsResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readValidationRuleResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadValidationRuleResult result;
    global readValidationRuleResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readVisualizationPluginResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadVisualizationPluginResult result;
    global readVisualizationPluginResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readWebLinkResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadWebLinkResult result;
    global readWebLinkResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readWorkflowActionResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadWorkflowActionResult result;
    global readWorkflowActionResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readWorkflowAlertResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadWorkflowAlertResult result;
    global readWorkflowAlertResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readWorkflowFieldUpdateResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadWorkflowFieldUpdateResult result;
    global readWorkflowFieldUpdateResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readWorkflowKnowledgePublishResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadWorkflowKnowledgePublishResult result;
    global readWorkflowKnowledgePublishResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readWorkflowOutboundMessageResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadWorkflowOutboundMessageResult result;
    global readWorkflowOutboundMessageResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readWorkflowResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadWorkflowResult result;
    global readWorkflowResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readWorkflowRuleResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadWorkflowRuleResult result;
    global readWorkflowRuleResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readWorkflowSendResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadWorkflowSendResult result;
    global readWorkflowSendResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readWorkflowTaskResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadWorkflowTaskResult result;
    global readWorkflowTaskResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class readXOrgHubResponse_element implements Framework.MetadataService.IReadResponseElement {
    global Framework.MetadataService.ReadXOrgHubResult result;
    global readXOrgHubResponse_element() {

    }
    global Framework.MetadataService.IReadResult getResult() {
        return null;
    }
}
global class renameMetadataResponse_element {
    global Framework.MetadataService.SaveResult result;
    global renameMetadataResponse_element() {

    }
}
global class renameMetadata_element {
    global String newFullName;
    global String oldFullName;
    global String type_x;
    global renameMetadata_element() {

    }
}
global class retrieveResponse_element {
    global Framework.MetadataService.AsyncResult result;
    global retrieveResponse_element() {

    }
}
global class retrieve_element {
    global Framework.MetadataService.RetrieveRequest retrieveRequest;
    global retrieve_element() {

    }
}
global class updateMetadataResponse_element {
    global List<Framework.MetadataService.SaveResult> result;
    global updateMetadataResponse_element() {

    }
}
global class updateMetadata_element {
    global List<Framework.MetadataService.Metadata> metadata;
    global updateMetadata_element() {

    }
}
global class upsertMetadataResponse_element {
    global List<Framework.MetadataService.UpsertResult> result;
    global upsertMetadataResponse_element() {

    }
}
global class upsertMetadata_element {
    global List<Framework.MetadataService.Metadata> metadata;
    global upsertMetadata_element() {

    }
}
}
