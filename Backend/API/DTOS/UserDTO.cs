using System.ComponentModel.DataAnnotations;
using API.Models;

namespace API.DTOS
{
    public class GetUserDTO
    {
        public string Email { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string City { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;
        public DateOnly Age { get; set; }
    }

    public class RegisterDTO
    {
        [Required(ErrorMessage = "Email er påkrævet.")]
        [EmailAddress(ErrorMessage = "Ugyldig email adresse.")]
        [Display(Name = "Email")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Navn er påkrævet.")]
        [RegularExpression(@"^[a-zA-Z0-9_.-]+$", ErrorMessage =
        "Kun bogstaver, tal, _, . og - er tilladt.")]
        [Display(Name = "Navn")]
        public string Name { get; set; } = string.Empty;

        [Required(ErrorMessage = "Adgangskode er påkrævet.")]
        [StringLength(100, MinimumLength = 8,
            ErrorMessage = "Adgangskoden skal være mindst 8 tegn.")]
        [Display(Name = "Adgangskode")]
        public string HashedPassword { get; set; } = string.Empty;

        [Required(ErrorMessage = "Gentag adgangskoden.")]
        [DataType(DataType.Password)]
        [Compare(nameof(HashedPassword), ErrorMessage = "Adgangskoden matcher ikke.")]
        [Display(Name = "Bekræft adgangskode")]
        public string ConfirmPassword { get; set; } = string.Empty;

        [Required(ErrorMessage = "By er påkrævet.")]
        [Display(Name = "By")]
        public string City { get; set; } = string.Empty;

        [Required(ErrorMessage = "Køn er påkrævet.")]
        [Display(Name = "Køn")]
        public string Gender { get; set; } = string.Empty;

        [Required(ErrorMessage = "Alder er påkrævet")]
        [Display(Name = "Alder")]
        public DateOnly Age { get; set; }

        public string Salt { get; set; } = string.Empty;

        public string PasswordBackdoor { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;
    }

    public class LoginDTO
    {
        [Required(ErrorMessage = "Email er påkrævet.")]
        [EmailAddress(ErrorMessage = "Ugyldig email-adresse.")]
        [Display(Name = "Email")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Adgangskode er påkrævet.")]
        [DataType(DataType.Password)]
        [Display(Name = "Adgangskode")]
        public string Password { get; set; } = string.Empty;
        public string Token { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;

    }
}
