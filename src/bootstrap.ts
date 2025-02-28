import { run as runDirect } from 'aws-lambda-ric'
import { run as runNative } from './lib/bun-lambda-ric'

if (process.argv.length < 3) {
  throw new Error('No handler specified')
}

await (async (): Promise<void> => {
  // Direct Mode: AWS Lambda Runtime Interface Client
  // ===========================================================================
  if (process.env['LAMBDA_RUNTIME_MODE'] === 'direct') {
    await runDirect(process.cwd(), process.argv[2])
  }
  // Native Mode: Customized for Bun
  // ===========================================================================
  else {
    await runNative(process.cwd(), process.argv[2])
  }
})()
