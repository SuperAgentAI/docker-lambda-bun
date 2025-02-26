import config from '@rogwilco/defaults-eslint'
import type { Linter } from 'eslint'

export default [
  ...config,
] satisfies Linter.Config[]
