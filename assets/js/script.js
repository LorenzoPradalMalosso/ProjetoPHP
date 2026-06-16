document.addEventListener("DOMContentLoaded", function () {
    var navIcons = [
        ["dashboard.php", "layout-dashboard"],
        ["perfil.php", "user-round"],
        ["progressoes.php", "route"],
        ["especialidades.php", "badge-check"],
        ["logout.php", "log-out"]
    ];

    document.querySelectorAll(".app-nav a").forEach(function (link) {
        var href = link.getAttribute("href") || "";
        var iconName = null;

        navIcons.forEach(function (entry) {
            if (href.indexOf(entry[0]) !== -1) {
                iconName = entry[1];
            }
        });

        if (!iconName && link.textContent.indexOf("Conquistas") !== -1) {
            iconName = "trophy";
        }

        if (!iconName && link.textContent.indexOf("Atividades") !== -1) {
            iconName = "calendar-days";
        }

        if (!iconName || link.querySelector("i[data-lucide]")) {
            return;
        }

        var marker = link.querySelector("span");
        var icon = document.createElement("i");
        icon.setAttribute("data-lucide", iconName);

        if (marker) {
            marker.replaceWith(icon);
        } else {
            link.prepend(icon);
        }
    });

    document.querySelectorAll(".menu-button").forEach(function (button) {
        if (button.querySelector("i[data-lucide]")) {
            return;
        }

        button.textContent = "";
        var icon = document.createElement("i");
        icon.setAttribute("data-lucide", "menu");
        button.appendChild(icon);
    });

    var cardIconMap = {
        ".context-icon:not(.green)": "compass",
        ".context-icon.green": "users-round",
        ".metric-icon:not(.gold):not(.blue)": "badge-check",
        ".metric-icon.gold": "trophy",
        ".metric-icon.blue": "star"
    };

    Object.keys(cardIconMap).forEach(function (selector) {
        document.querySelectorAll(selector).forEach(function (target) {
            if (target.querySelector("i[data-lucide]")) {
                return;
            }

            target.textContent = "";
            var icon = document.createElement("i");
            icon.setAttribute("data-lucide", cardIconMap[selector]);
            target.appendChild(icon);
        });
    });

    function calculateSpecialtyLevel(totalItems, completedItems, minLevelOne, minLevelTwo) {
        if (completedItems >= totalItems) {
            return 3;
        }

        if (completedItems >= minLevelTwo) {
            return 2;
        }

        if (completedItems >= minLevelOne) {
            return 1;
        }

        return 0;
    }

    function updateSpecialtyLevel(specialtyId) {
        var items = Array.prototype.slice.call(document.querySelectorAll('[data-specialty-item="' + specialtyId + '"]'));
        var output = document.querySelector('[data-auto-level-for="' + specialtyId + '"]');

        if (!items.length || !output) {
            return;
        }

        var firstItem = items[0];
        var totalItems = parseInt(firstItem.getAttribute("data-total-items"), 10) || items.length;
        var minLevelOne = parseInt(firstItem.getAttribute("data-min-level-one"), 10) || 1;
        var minLevelTwo = parseInt(firstItem.getAttribute("data-min-level-two"), 10) || totalItems;
        var completedItems = items.filter(function (item) {
            return item.checked;
        }).length;
        var level = calculateSpecialtyLevel(totalItems, completedItems, minLevelOne, minLevelTwo);

        if (level === 0) {
            output.textContent = completedItems === 0
                ? "Selecione os itens"
                : completedItems + "/" + totalItems + " itens";
        } else {
            output.textContent = "Nivel " + level + " (" + completedItems + "/" + totalItems + ")";
        }

        items.forEach(function (item) {
            item.setCustomValidity("");
        });
    }

    document.querySelectorAll("[data-specialty-item]").forEach(function (item) {
        item.addEventListener("change", function () {
            updateSpecialtyLevel(item.getAttribute("data-specialty-item"));
        });

        updateSpecialtyLevel(item.getAttribute("data-specialty-item"));
    });

    document.querySelectorAll('form[id^="especialidade-form-"]').forEach(function (form) {
        form.addEventListener("submit", function (event) {
            var specialtyId = form.id.replace("especialidade-form-", "");
            var items = Array.prototype.slice.call(document.querySelectorAll('[data-specialty-item="' + specialtyId + '"]'));

            if (!items.length) {
                return;
            }

            var firstItem = items[0];
            var totalItems = parseInt(firstItem.getAttribute("data-total-items"), 10) || items.length;
            var minLevelOne = parseInt(firstItem.getAttribute("data-min-level-one"), 10) || 1;
            var checkedItems = items.filter(function (item) {
                return item.checked;
            });

            if (checkedItems.length === 0) {
                firstItem.setCustomValidity("Selecione pelo menos um item concluido.");
                firstItem.reportValidity();
                event.preventDefault();
                return;
            }

            if (checkedItems.length < minLevelOne) {
                firstItem.setCustomValidity("Selecione pelo menos " + minLevelOne + " item(ns) para atingir o nivel 1.");
                firstItem.reportValidity();
                event.preventDefault();
                return;
            }

            firstItem.setCustomValidity("");
            updateSpecialtyLevel(specialtyId);
        });
    });

    if (window.lucide) {
        window.lucide.createIcons();
    }
});
