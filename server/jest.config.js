/** Jest config — unit + integration tests for auth/authz/account-deletion. */
module.exports = {
  moduleFileExtensions: ['js', 'json', 'ts'],
  rootDir: 'src',
  testRegex: '.*\\.spec\\.ts$',
  transform: {
    '^.+\\.ts$': ['ts-jest', { tsconfig: '<rootDir>/../tsconfig.json' }],
  },
  collectCoverageFrom: ['**/*.(t|j)s'],
  coverageDirectory: '../coverage',
  testEnvironment: 'node',
  moduleNameMapper: {
    '^@app/(.*)$': '<rootDir>/$1',
  },
  // 集成 spec 共用同一个数据库,且各自 beforeEach 全表 deleteMany 做隔离;
  // 若并行(默认多 worker)会互相清库导致间歇性失败(record not found / 计数为 0)。
  // 故强制串行执行,保证集成测试相互隔离。
  maxWorkers: 1,
};
