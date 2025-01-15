// Import necessary CDK libraries
import * as cdk from 'aws-cdk-lib';
import * as amplify from 'aws-cdk-lib/aws-amplify';

export class HugoAmplifyStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const amplifyApp = new amplify.App(this, 'HugoAmplifyApp', {
      sourceCodeProvider: new amplify.GitHubSourceCodeProvider({
        owner: 'your-github-username', // TODO: finalized github usernam
        repository: 'pace-lecture-series', // TODO: finalized github repository
        oauthToken: cdk.SecretValue.secretsManager('github-token'), // FIXME: please do not add your secret key!
      }),
    });

    // TODO: branch name for CI/CD
    const mainBranch = amplifyApp.addBranch('main');

    // Configure build settings for Hugo
    amplifyApp.addCustomRule({
      source: '*',
      target: '/index.html',
      status: amplify.RedirectStatus.NOT_FOUND_REWRITE,
    });

    amplifyApp.addEnvironment('HUGO_VERSION', '0.140.2'); // FIXME: update Hugo version to the latest

    amplifyApp.addCustomResource({
      resourceName: 'HugoBuildSettings',
      properties: {
        buildSpec: {
          version: 1,
          frontend: {
            phases: {
              preBuild: {
                commands: ['hugo version'],
              },
              build: {
                commands: ['hugo'],
              },
            },
            artifacts: {
              baseDirectory: 'public',
              files: ['**/*'],
            },
            cache: {
              paths: ['node_modules/**/*'],
            },
          },
        },
      },
    });
  }
}

const app = new cdk.App();
new HugoAmplifyStack(app, 'HugoAmplifyStack');
app.synth();
