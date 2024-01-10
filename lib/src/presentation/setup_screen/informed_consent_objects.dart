import 'package:research_package/research_package.dart';

RPConsentSection overviewSection = RPConsentSection(
    type: RPConsentSectionType.Overview,
    summary: "Welcome to our health app research study.",
    content:
        "In this study, we will be collecting data about your daily activities and health information to help your health practitioners adminstrate your dose of medication.");

// Data Gathering Section
RPConsentSection dataGatheringSection = RPConsentSection(
    type: RPConsentSectionType.DataGathering,
    summary: "How we gather your data.",
    content:
        "We use sensors and manual input to collect your data. This includes steps, heart rate, weight, location and other metrics.");

// Privacy Section
RPConsentSection privacySection = RPConsentSection(
    type: RPConsentSectionType.Privacy,
    summary: "Your data is private.",
    content:
        "We take privacy seriously. Your data is stored on our secure servers and is only accessible by your health practitioner.");

// Passive Data Collection Section
RPConsentSection passiveDataCollection = RPConsentSection(
    type: RPConsentSectionType.PassiveDataCollection,
    summary: "Data we collect in the background.",
    dataTypes: [
      RPDataTypeSection(
          dataName: "Steps",
          dataInformation: "Your daily step counts as collected by the phone."),
      RPDataTypeSection(
          dataName: "Location",
          dataInformation:
              "Your location to track how much time you spent at home."),
      RPDataTypeSection(
          dataName: "Heart Rate",
          dataInformation: "Your heart rate data as collected by health tracking wearables."
      )
    ]);

RPConsentSection userDataCollection = RPConsentSection(
  type: RPConsentSectionType.UserDataCollection,
  summary: "This is a summary for User Data Collection i.e. you will need to provide the information about the following categories.",
  dataTypes: [
    RPDataTypeSection(
      dataName: "Weight", 
      dataInformation: "You will need to provide information about your weight."),
    RPDataTypeSection(
      dataName: "Home Address", 
      dataInformation: "You will need to provide information about your Home Address."),
  ]
);

RPCompletionStep completionStep = RPCompletionStep(
    identifier: "completionID",
    title: "Thank You!",
    text: "We saved your consent.");

RPConsentDocument myConsentDocument = RPConsentDocument(
  title: 'Health App Informed Consent',
  sections: [
    overviewSection,
    dataGatheringSection,
    privacySection,
    passiveDataCollection,
    userDataCollection,
  ],
);
RPVisualConsentStep consentVisualStep = RPVisualConsentStep(
    identifier: "visualStep", consentDocument: myConsentDocument);

RPConsentReviewStep consentReviewStep = RPConsentReviewStep(
  identifier: "consentreviewstepID",
  title: 'Consent Review',
  consentDocument: myConsentDocument,
  reasonForConsent:
      'By tapping AGREE you confirm that you read the consent information and allow us to collect your data',
  text: 'Agreed?',
);

RPOrderedTask consentTask = RPOrderedTask(
  identifier: "consentTaskID",
  steps: [
    consentVisualStep,
    consentReviewStep,
    completionStep,
  ],
);
