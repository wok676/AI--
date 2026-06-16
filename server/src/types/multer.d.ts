/**
 * 最小 multer 声明:仅声明本项目用到的 memoryStorage(避免引入完整 @types/multer 依赖)。
 * memoryStorage 保证上传文件只进内存 buffer,不落磁盘(配合原图最小化留存 §4.7)。
 */
declare module 'multer' {
  interface StorageEngine {
    _handleFile(...args: unknown[]): void;
    _removeFile(...args: unknown[]): void;
  }
  export function memoryStorage(): StorageEngine;
}
