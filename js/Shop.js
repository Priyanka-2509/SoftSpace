function viewDetails(btn) {
    const card = btn.closest('.product-card');

    document.getElementById("modalName").innerText =
        card.dataset.name;

    document.getElementById("modalDesc").innerText =
        card.dataset.desc;

    document.getElementById("modalPrice").innerText =
        "₹" + card.dataset.price;

    document.getElementById("modalImg").src =
        card.dataset.img;

    document.getElementById("detailsModal").style.display = "flex";
}

function closeModal() {
    document.getElementById("detailsModal").style.display = "none";
}

function orderNow(btn) {
    const card = btn.closest('.product-card');
    alert(
        "Order placed for " +
        card.dataset.name +
        "\nStatus: Pending"
    );

    // LATER:
    // INSERT INTO Orders (UserId, ProductName, Status)
}
