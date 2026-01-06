# CleerSplit

CleerSplit is a full-stack iOS application for managing shared expenses among friends, roommates, families, and teams. The app focuses on clarity, transparency, and reducing friction around group finances through a clean, intuitive user experience.

This project is being built end-to-end as a real product, covering design, frontend engineering, backend services, testing, and deployment.

---

## 🚧 Status

**MVP — In Progress**

CleerSplit is under active development, with a focus on delivering a stable, well-architected MVP before expanding features and optimizations.

---

## 🎯 MVP Scope

- Group-based expense tracking
- Add and manage shared expenses
- Automatic balance calculations (who owes who)
- Group expense summaries
- Structured onboarding and welcome flow
- Reusable, scalable UI components

Planned for later iterations:
- Authentication & user accounts
- Automated reminders
- Payment integrations
- Accessibility refinements
- Performance and UX optimizations

---

## 🧱 Architecture & Engineering Approach

- **SwiftUI** with **MVVM (Model–View–ViewModel)** architecture
- Clear separation of views, state, and business logic
- Reusable, component-driven UI
- Modern concurrency using async/await
- Designed for scalability and maintainability

---

## 🛠️ Tech Stack

### Prototyping & Design
- Figma
- FigJam
- Figma Dev Mode

### Frontend (iOS)
- Swift
- SwiftUI
- Xcode
- Combine
- Async/Await
- MVVM Architecture

### Backend
- Supabase
- PostgreSQL
- Python
- OpenAI / ML models *(planned / experimental)*

### DevOps & Deployment
- Git & GitHub
- CI/CD (in progress)
- Docker
- Apple App Store Connect
- TestFlight

### Testing
- XCTest
- XCUITest
- Swift Testing

---

## 🧠 Product & Engineering Focus

- Translating high-fidelity designs into production SwiftUI
- Building reusable, scalable UI components
- Structuring application state and navigation cleanly
- Incremental development with small, meaningful commits
- End-to-end ownership: design → build → test → deploy

---

## 👩🏽‍💻 Author

**Ruth Okolo**  
iOS Engineer  
Portfolio: https://ruthokolo.com

---

## 🔐 Security & Privacy

CleerSplit is built with security-first defaults.

- **No secrets in Git**: API keys, Supabase credentials, and environment files are excluded via `.gitignore`.
- **Environment-based configuration**: Sensitive values are loaded from `.env` / build-time config, never hardcoded.
- **Least-privilege access**: The app uses **public/anonymous** client keys only. Admin/service-role keys are kept server-side and never shipped in the iOS app.
- **Data protection**: Planned backend policies (Supabase RLS) will ensure users can only access their own data.
- **Responsible logging**: No sensitive values are printed to console logs in production builds.

If you believe you’ve found a security issue, please open a GitHub issue with **minimal details** and label it `security`.


## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

