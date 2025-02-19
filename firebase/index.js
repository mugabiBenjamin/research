import { initializeApp } from "firebase/app";

// replace 'getDocs' with 'onSnapshot'
import {
  getFirestore,
  collection,
  onSnapshot,
  addDoc,
  deleteDoc,
  doc,
  query,
  where,
  orderBy,
  serverTimestamp,
  getDoc,
  updateDoc,
} from "firebase/firestore";

import {
  getAuth,
  createUserWithEmailAndPassword,
  signOut,
  signInWithEmailAndPassword,
  onAuthStateChanged,
} from "firebase/auth";

// firebase config
const firebaseConfig = {
  apiKey: import.meta.env.VITE_API_KEY,
  authDomain: import.meta.env.VITE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_APP_ID,
};

// init firebase app
initializeApp(firebaseConfig);

// init services
const db = getFirestore();
const auth = getAuth();

// collection ref
const colRef = collection(db, "books");

// queries
const q = query(colRef, orderBy("createdAt"));
// const q = query((colRef), where('author', '==', 'patrick rothfuss'), orderBy('title', 'desc'));

// get collection data
// getDocs(colRef)
//     .then((snapshot) => {
//         let books = [];
//         snapshot.docs.forEach(doc => {
//             books.push({ ...doc.data(), id: doc.id });
//         });
//     console.log(books);
//     })
//     .catch((error) => {
//         console.log('Error getting documents: ', error);
// });

// realtime collection data
const unsubCol = onSnapshot(q, (snapshot) => {
  let books = [];
  snapshot.docs.forEach((doc) => {
    books.push({ ...doc.data(), id: doc.id });
  });
  console.log("All books retrived", books);
});

// adding documents
const addBookFrom = document.querySelector(".add");
addBookFrom.addEventListener("submit", (e) => {
  e.preventDefault();

  addDoc(colRef, {
    title: addBookFrom.title.value,
    author: addBookFrom.author.value,
    createdAt: serverTimestamp(),
  }).then(() => {
    console.log("Book successfully added!");
    addBookFrom.reset();
  });
});

// deleting documents
const deleteBookFrom = document.querySelector(".delete");
deleteBookFrom.addEventListener("submit", (e) => {
  e.preventDefault();

  const docRef = doc(db, "books", deleteBookFrom.id.value);

  deleteDoc(docRef).then(() => {
    console.log("Book successfully deleted!");
    deleteBookFrom.reset();
  });
});

// get single document
const docRef = doc(db, "books", "yYJQumsUsJ2KicSq9JcH");

const unsubDoc = onSnapshot(docRef, (doc) => {
  console.log("Current data: ", doc.data(), doc.id);
});

// updating a document
const updateFrom = document.querySelector(".update");
updateFrom.addEventListener("submit", (e) => {
  e.preventDefault();

  const docRef = doc(db, "books", updateFrom.id.value);

  // Prompting the user for the new title
  const newTitle = prompt("Please enter the new title for the book:");

  if (newTitle) {
    updateDoc(docRef, {
      title: newTitle,
    })
      .then(() => {
        console.log("Book successfully updated!");
        updateFrom.reset();
      })
      .catch((error) => {
        console.error("Error updating document: ", error);
      });
  } else {
    console.log("No title entered. Update cancelled.");
  }
});

// authentication
const signUpForm = document.querySelector(".signup");
signUpForm.addEventListener("submit", (e) => {
  e.preventDefault();

  const email = signUpForm.email.value;
  const password = signUpForm.password.value;

  createUserWithEmailAndPassword(auth, email, password)
    .then((userCredential) => {
      const user = userCredential.user;
      console.log("User created: ", user);
      signUpForm.reset();
    })
    .catch((error) => {
      const errorCode = error.code;
      const errorMessage = error.message;
      console.log(errorCode, errorMessage);
    });
});

// logging in and out
const logoutButton = document.querySelector(".logout");
logoutButton.addEventListener("click", () => {
  // console.log('Logout button clicked');
  signOut(auth)
    .then(() => {
      console.log("User signed out");
    })
    .catch((error) => {
      const errorCode = error.code;
      const errorMessage = error.message;
      console.log(errorCode, errorMessage);
    });
});

const loginForm = document.querySelector(".login");
loginForm.addEventListener("submit", (e) => {
  e.preventDefault();

  const email = loginForm.email.value;
  const password = loginForm.password.value;

  signInWithEmailAndPassword(auth, email, password)
    .then((userCredential) => {
      const user = userCredential.user;
      console.log("User signed in: ", user);
      loginForm.reset();
    })
    .catch((error) => {
      const errorCode = error.code;
      const errorMessage = error.message;
      console.log(errorCode, errorMessage);
    });
});

// subsrcibe to auth state changes
const unsubAuth = onAuthStateChanged(auth, (user) => {
  if (user) {
    console.log("User logged in: ", user);
  } else {
    console.log("User logged out");
  }
});

// unsubscribe from changes (auth & db)
document.addEventListener("DOMContentLoaded", () => {
  const unsubButton = document.querySelector(".unsubs");
  unsubButton.addEventListener("click", () => {
    console.log("Unsubscribed");

    unsubCol();
    unsubDoc();
    unsubAuth();
  });
});
