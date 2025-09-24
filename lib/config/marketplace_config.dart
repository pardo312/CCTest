enum MarketplaceType {
  course,
  api,
  digital,
  service,
  information,
  subscription
}

abstract class MarketplaceConfig {
  final MarketplaceType type;
  final bool enabled;
  final Map<String, dynamic> settings;
  final List<String> requiredModules;
  final List<String> optionalModules;

  MarketplaceConfig({
    required this.type,
    required this.enabled,
    required this.settings,
    required this.requiredModules,
    required this.optionalModules,
  });
}

class CourseMarketplaceConfig extends MarketplaceConfig {
  CourseMarketplaceConfig()
      : super(
          type: MarketplaceType.course,
          enabled: true,
          settings: {
            'videoProviders': ['vimeo', 'youtube', 'bunny'],
            'maxVideoSizeMB': 5000,
            'allowDownloads': true,
            'certificateEnabled': true,
            'discussionEnabled': true,
            'assignmentsEnabled': true,
            'quizEnabled': true,
            'completionThreshold': 0.8,
            'previewLessons': 3,
          },
          requiredModules: ['auth', 'payment', 'marketplace_core'],
          optionalModules: ['reviews', 'chat'],
        );
}

class ApiMarketplaceConfig extends MarketplaceConfig {
  ApiMarketplaceConfig()
      : super(
          type: MarketplaceType.api,
          enabled: true,
          settings: {
            'sandboxEnabled': true,
            'rateLimiting': true,
            'usageTracking': true,
            'apiKeyRotation': true,
            'webhooksEnabled': true,
          },
          requiredModules: ['auth', 'payment', 'marketplace_core', 'api_management'],
          optionalModules: ['analytics', 'monitoring'],
        );
}

class DigitalMarketplaceConfig extends MarketplaceConfig {
  DigitalMarketplaceConfig()
      : super(
          type: MarketplaceType.digital,
          enabled: true,
          settings: {
            'maxFileSizeMB': 500,
            'allowedFormats': ['pdf', 'zip', 'png', 'jpg', 'svg', 'psd', 'ai'],
            'downloadLimitEnabled': true,
            'defaultDownloadLimit': 5,
            'licenseManagement': true,
            'versionControl': true,
          },
          requiredModules: ['auth', 'payment', 'marketplace_core', 'storage'],
          optionalModules: ['reviews', 'licensing'],
        );
}