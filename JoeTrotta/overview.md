I’d like to make a simple but detailed ‘security badge’ for websites to display their security practices up front to users.  It would be the next stage of the ‘padlock’ icon -- instead of just representing that the website is ‘secure’ (whatever that means) it actually tells the users what measures are taken to ensure that their data is safe.  Furthermore, it would provide technical information to more advanced users so that the website’s claims can be verified by any independent observer.

The model I’m currently envisioning has several ‘objective’ boxes and several ‘subjective’ boxes.  The ‘objective’ boxes will each get a rating from 1-5 stars, and the website will be given an overall score equal to their lowest objective subscore.  The subjective boxes would give information that is important to users of the website, but that users can make informed decisions about.  

Example ‘objective’ boxes:
* Authentication security
  * Score based primarily on storage of passwords
    * 5 - Salted and one-way strongly hashed password
    * 4 - Salted and one-way weakly hashed password
    * 3 - One way strongly hashed password
    * 2 - One way weakly hashed password or two way encryption
    * 1 - Plaintext passwords
  * Penalties based on password strength requirements
    * -1: does not check for passwords containing username
    * -2: allows passwords below 9 characters
    * -1: allows passwords consisting of only numbers
  * Websites using outside authentication (OAuth, Single Sign On, etc) uses the lower score of the outside authentication system or the on site system, if one exists
* Encryption of personal data
  * Score based on strength of encryption system
    * Based on amount of time needed to break encryption
    * Scale will change over time as system power increases
  * Penalties
    * Penalty for encryption systems that don’t check for weak keys
    * More research needed

Example ‘subjective’ boxes:
* Information retention
  * Personally identifiable/sensitive information?
  * How long is it kept after you ask to delete it?
* Data distribution
  * Based off of privacy policy
  * Explain explicitly how data can be shared internally and externally
  * Don’t include situations regarding subpoenas etc -- not much a company can do here
* Transparency (could also be objective?)
  * To what extent can users see the information collected about them?
  * To what extent can users ask to delete information? 
