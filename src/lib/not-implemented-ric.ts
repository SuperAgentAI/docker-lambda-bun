export type LambdaRuntime = (cwd: string, handler: string) => Promise<void>

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
// eslint-disable-next-line @typescript-eslint/no-unused-vars
export const run: LambdaRuntime = async (cwd: string, handler: string) => {
  return Promise.reject(new Error('Not implemented'))
}
