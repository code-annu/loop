# 🎵 Loop Backend API

A modern, scalable REST API backend for the **Loop** music streaming application. Built with TypeScript following Clean Architecture principles for maintainability, testability, and extensibility.

---

## ✨ Features

- **Clean Architecture** — Layered structure with clear separation of concerns
- **Type-Safe** — Full TypeScript implementation with strict typing
- **Dependency Injection** — InversifyJS for loose coupling and testability
- **Input Validation** — Zod schemas for request validation
- **Structured Error Handling** — Custom error classes with consistent API responses
- **Database ORM** — Prisma ORM with Supabase PostgreSQL
- **Extensible** — Easy to add new features and endpoints

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Node.js** | JavaScript runtime |
| **Express.js** | Web framework for REST API |
| **TypeScript** | Type safety and developer experience |
| **Prisma** | Type-safe ORM for database operations |
| **Supabase** | PostgreSQL database hosting |
| **InversifyJS** | Dependency injection container |
| **Zod** | Schema validation for API requests |

---

## 📁 Folder Structure

```
src/
├── api/                    # API Layer - HTTP handling
│   ├── controllers/        # Request handlers
│   ├── middleware/         # Express middleware (error handling, etc.)
│   ├── responses/          # Response formatters
│   ├── routes/             # Route definitions
│   └── schemas/            # Zod validation schemas
│
├── application/            # Application Layer - Business logic
│   └── usecases/           # Use case implementations
│       ├── album/
│       ├── artist/
│       └── track/
│
├── domain/                 # Domain Layer - Core business entities
│   ├── entities/           # Business entities (Track, Album, Artist)
│   └── repositories/       # Repository interfaces (contracts)
│
├── infrastructure/         # Infrastructure Layer - External services
│   ├── database/           # Database client configuration
│   ├── mappers/            # Prisma to Domain entity mappers
│   └── repositories/       # Repository implementations
│
├── di/                     # Dependency Injection
│   ├── container.ts        # Inversify container configuration
│   ├── types.ts            # DI injection tokens
│   └── index.ts
│
├── util/                   # Utilities
│   └── logger.ts           # Logging utility
│
└── server.ts               # Application entry point
```

### Layer Responsibilities

| Layer | Responsibility |
|-------|---------------|
| **API** | Handle HTTP requests/responses, validation, routing |
| **Application** | Orchestrate use cases, business rules |
| **Domain** | Define entities, repository interfaces |
| **Infrastructure** | Implement database access, external services |
| **DI** | Wire up dependencies at runtime |

---

## 📡 API Documentation

### Base URL

```
http://localhost:3000/api/v1
```

### Endpoints

#### Tracks

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/tracks/random` | Get random tracks |
| `GET` | `/tracks/:id` | Get track by ID |

#### Albums

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/albums/random` | Get random albums |
| `GET` | `/albums/:id` | Get album by ID |

#### Artists

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/artists/random` | Get random artists |
| `GET` | `/artists/:id` | Get artist by ID |

#### Health Check

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/health` | Check API status |

### Response Format

#### Success Response

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "id": "uuid",
    "title": "Song Title",
    "coverUrl": "https://...",
    "trackUrl": "https://...",
    "duration": 240,
    "artists": [
      { "id": "uuid", "name": "Artist Name" }
    ]
  }
}
```

#### Error Response

```json
{
  "status": "failed",
  "code": 404,
  "error": {
    "type": "NotFoundError",
    "message": "Track not found"
  }
}
```

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** v18+ 
- **npm** or **yarn**
- **Supabase** account with PostgreSQL database

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/loop-backend.git
   cd loop-backend
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Set up environment variables**

   Create a `.env` file in the root directory:

   ```env
   # Database
   DATABASE_URL="postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres"

   # Server
   PORT=3000
   NODE_ENV=development
   ```

4. **Generate Prisma client**

   ```bash
   npm run prisma:generate
   ```

5. **Push database schema**

   ```bash
   npm run prisma:push
   ```

6. **Start the development server**

   ```bash
   npm run dev
   ```

The API will be running at `http://localhost:3000`

### Available Scripts

| Script | Description |
|--------|-------------|
| `npm run dev` | Start development server with hot reload |
| `npm run build` | Compile TypeScript to JavaScript |
| `npm start` | Run production build |
| `npm run prisma:generate` | Generate Prisma client |
| `npm run prisma:push` | Push schema to database |
| `npm run prisma:studio` | Open Prisma Studio GUI |

---

## 🗄️ Database

### Prisma Schema

The project uses Prisma ORM with the following models:

- **Artist** — Music artists
- **Album** — Music albums with artist relations
- **Track** — Individual tracks with album and artist relations
- **AlbumArtist** — Many-to-many relation between albums and artists
- **TrackArtist** — Many-to-many relation between tracks and artists

### Migrations

```bash
# Push schema changes to database
npm run prisma:push

# Open Prisma Studio to manage data
npm run prisma:studio
```

### Supabase Setup

1. Create a new project on [Supabase](https://supabase.com)
2. Navigate to **Settings → Database**
3. Copy the connection string
4. Replace `[PASSWORD]` with your database password
5. Add to your `.env` file as `DATABASE_URL`

---

## ⚠️ Error Handling

The API uses custom error classes for structured error handling:

| Error Class | HTTP Code | Description |
|-------------|-----------|-------------|
| `NotFoundError` | 404 | Resource not found |
| `ValidationError` | 400 | Invalid request data |
| `AuthenticationError` | 401 | Authentication required |
| `AuthorizationError` | 403 | Insufficient permissions |

All errors are caught by the global error middleware and formatted consistently.

---

## 🔌 Dependency Injection

InversifyJS is used for dependency injection, configured in `src/di/container.ts`:

```typescript
// Repositories are bound to their interfaces
container.bind<ITrackRepository>(TYPES.TrackRepository)
  .to(PrismaTrackRepository).inSingletonScope();

// Use cases receive repositories via constructor injection
container.bind<GetTrackByIdUseCase>(TYPES.GetTrackByIdUseCase)
  .to(GetTrackByIdUseCase).inSingletonScope();

// Controllers receive use cases via constructor injection
container.bind<TrackController>(TYPES.TrackController)
  .to(TrackController).inSingletonScope();
```

This enables:
- Easy testing with mock implementations
- Loose coupling between layers
- Single responsibility principle

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Guidelines

- Follow the existing code style
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed

---

## 📄 License

This project is licensed under the **ISC License** — see the [LICENSE](LICENSE) file for details.

---

## 🔮 Future Roadmap

- [ ] JWT Authentication & Authorization
- [ ] User registration and profiles
- [ ] Playlist management
- [ ] Search functionality
- [ ] Streaming with range requests
- [ ] Rate limiting
- [ ] API versioning
- [ ] Swagger/OpenAPI documentation

---

## 📬 Contact

For questions or support, please open an issue on GitHub.

---

<p align="center">
  Built with ❤️ for music lovers
</p>
