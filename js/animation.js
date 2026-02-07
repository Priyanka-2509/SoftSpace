document.addEventListener("DOMContentLoaded", function () {

    // Create an observer options object
    const observerOptions = {
        root: null,         // Use the viewport as root
        rootMargin: "0px",  // No margin
        threshold: 0.15     // Trigger when 15% of the element is visible
    };

    // The Observer Callback
    const observerCallback = (entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // Add 'show' class to trigger CSS transition
                entry.target.classList.add("show");

                //  Stop observing once animated (for run-once animation)
                observer.unobserve(entry.target);
            }
        });
    };

    // Initialize Observer
    const observer = new IntersectionObserver(observerCallback, observerOptions);

    // Select all elements with the 'hidden-el' class
    const hiddenElements = document.querySelectorAll(".hidden-el");
    hiddenElements.forEach(el => observer.observe(el));
});
