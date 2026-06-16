// 管理后台 i18n(en)。包含:
//  - 后端错误 messageKey 子集(与 /locales/en.json 对齐,用于渲染统一错误响应);
//  - 管理后台 UI 文案(admin.* 命名空间)。
// 禁止硬编码文案(宪法 §7),所有可见文字走 t()。
const en = {
  common: {
    appName: 'TestAI Admin',
    ok: 'OK',
    save: 'Save',
    cancel: 'Cancel',
    confirm: 'Confirm',
    retry: 'Retry',
    loading: 'Loading…',
    empty: 'Nothing here yet',
    error: {
      generic: 'Something went wrong. Please try again.',
      network: 'Network error. Please check your connection.',
      timeout: 'Request timed out. Please try again.',
    },
  },
  errors: {
    unauthorized: 'Session expired, please log in again',
    forbidden: 'You are not allowed to perform this action',
    notFound: 'Resource not found',
    validation: 'Invalid input, please check and retry',
  },
  auth: {
    error: { invalidCredentials: 'Incorrect email or password' },
    email: { invalid: 'Invalid email address' },
    password: { weak: 'Weak password. Use letters and numbers.' },
  },
  admin: {
    login: {
      title: 'Admin Console',
      subtitle: 'Sign in with an administrator account',
      email: 'Email',
      password: 'Password',
      submit: 'Sign in',
      notAdmin: 'This account is not an administrator',
    },
    nav: {
      dashboard: 'Dashboard',
      users: 'Users',
      logout: 'Log out',
    },
    dashboard: {
      title: 'Operations dashboard',
      totalUsers: 'Total users',
      activeUsers: 'Active users',
      bannedUsers: 'Banned users',
      newUsersToday: 'New today',
      recognitionTotal: 'Recognition calls',
      recognitionSuccess: 'Successful calls',
      failureRate: 'Failure rate',
      trendTitle: 'Recognition calls (last {{days}} days)',
      trendDate: 'Date',
      trendTotal: 'Total',
      trendSuccess: 'Success',
      trendFailed: 'Failed',
      privacyNote:
        'All figures are aggregated and de-identified. No meal photos or personal meal details are accessible here.',
    },
    users: {
      title: 'User management',
      searchPlaceholder: 'Search by username or email',
      colUsername: 'Username',
      colEmail: 'Email (masked)',
      colRole: 'Role',
      colPlan: 'Plan',
      colStatus: 'Status',
      colCreatedAt: 'Created',
      colActions: 'Actions',
      view: 'View',
      ban: 'Ban',
      unban: 'Unban',
      banConfirm: 'Ban this user? They will be unable to log in.',
      unbanConfirm: 'Unban this user?',
      banned: 'User banned',
      unbanned: 'User unbanned',
      noEmail: '(no email)',
    },
    status: {
      ACTIVE: 'Active',
      BANNED: 'Banned',
    },
    detail: {
      title: 'User detail',
      back: 'Back to list',
      account: 'Account',
      activity: 'Activity (aggregated)',
      mealEntryCount: 'Meal entries',
      recognitionUsageTotal: 'Recognition usage (total)',
      authProviders: 'Login providers',
      locale: 'Locale',
      notifyEnabled: 'Notifications',
      consentAcceptedAt: 'Consent accepted at',
      consentVersion: 'Consent version',
      createdAt: 'Created',
      updatedAt: 'Updated',
      privacyNote:
        'Only counts are shown. Meal content, food details, and original photos are never exposed to admins.',
    },
  },
};

export default en;
export type Resources = typeof en;
