# Sistem Informasi Penggajian Karyawan

## API
The API uses Express, JSON Web Token, and Sequelize.<br>
Go to `api` directory and run `npm install` to install the dependencies.

Next, create a `.env` file and put the following into it:
```
DB_HOST=<your db host>
DB_PORT=<your db port>
DB_USER=<your db user>
DB_PASSWORD=<your db password>
DB_NAME=si_penggajian
PORT=<port for Express server>
SECRET=<secret-key-for-jwt>
```

*Make sure your MySQL server is up and running before proceeding.*

To create the database for this project, run this command:
```
npm run create-db
```

To seed the database with an initial set of data, run this command:
```
npm run seeder
```

To start the Express server, run this command:
```
npm start
```

## Flutter
The Flutter application uses Dio as HTTP client and BLoC as state management system.<br>
Go to `flutter` directory and run `flutter pub get` to install the dependencies.

To run the application on a connected device, use this command:
```
flutter run -d <device>
```