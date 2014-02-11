// taken from:
// http://cppsecrets.blogspot.co.uk/2013/11/ds-scope-statement-in-c.html


#include <exception>
#include <utility>
#include <type_traits>

template<typename F, typename CleanupPolicy>
class scope_guard : CleanupPolicy, CleanupPolicy::installer
{
    using CleanupPolicy::cleanup;
    using CleanupPolicy::installer::install;
    
    typename std::remove_reference<F>::type f_;
    
public:
    scope_guard(F&& f) : f_(std::forward<F>(f)) { 
        install();
    }
    ~scope_guard() {
    	cleanup(f_);
	}
};

struct unchecked_install_policy {
	void install() { }
};

struct checked_install_policy {
	void install() {
		if (std::uncaught_exception()) {
			std::terminate(); // sorry
		}
	}
};

struct exit_policy {
	typedef unchecked_install_policy installer;
	
    template<typename F>
    void cleanup(F& f) {
        f();
    }
};

struct failure_policy {
	typedef checked_install_policy installer;
	
    template<typename F>
    void cleanup(F& f) {
        // Only cleanup if we're exiting from an exception.
        if (std::uncaught_exception()) {
            f();
        }
    }
};

struct success_policy {
	typedef checked_install_policy installer;
	
    template<typename F>
    void cleanup(F& f) {
        // Only cleanup if we're NOT exiting from an exception.
        if (!std::uncaught_exception()) {
           f();
        }
    }
};

//////////////////////////////////////////////
// Syntactical sugar
//////////////////////////////////////////////

template<typename CleanupPolicy>
struct scope_guard_builder { };

template<typename F, typename CleanupPolicy>
scope_guard<F,CleanupPolicy> 
operator+(
	scope_guard_builder<CleanupPolicy> builder,
	F&& f
	)
{
	return std::forward<F>(f);
}

// typical preprocessor utility stuff.
#define PASTE_TOKENS2(a,b) a ## b
#define PASTE_TOKENS(a,b) PASTE_TOKENS2(a,b)

#define scope(condition) \
    auto PASTE_TOKENS(_scopeGuard, __LINE__) = \
        scope_guard_builder<condition##_policy>() + [&]

//////////////////////////////////////////////
// User code from here on
//////////////////////////////////////////////

#include <iostream>

struct HasScopeExitInDtor {
	~HasScopeExitInDtor() {
		scope (exit) {
			std::cout << "scope (exit) in dtor success test\n";
		};
		try {
			std::cout << "scope (exit) in dtor failure test\n";
			throw 1;
		} catch (...) { }
	}
};

struct HasScopeSuccessInDtor {
	~HasScopeSuccessInDtor() {
		std::cout << std::flush;
		scope (success) {
			std::cout << "error: scope (success) used in dtor\n";
		};
	}
};

int main()
{
	{
		const char* captureTest = nullptr;
		scope (exit) {
			std::cout << "scope (exit) success test\n";
			std::cout << "captureTest: " << captureTest;
		};
		scope (success) {
			std::cout << "scope (success) success test\n";
		};
		scope (failure) {
			std::cout << "scope (failure) success test\n";
		};
		captureTest = "ok\n";
	}
	try {
		HasScopeSuccessInDtor s;
		
		scope (exit) {
			std::cout << "scope (exit) failure test\n";
		};
		scope (success) {
			std::cout << "scope (success) failure test\n";
		};
		scope (failure) {
			std::cout << "scope (failure) failure test\n";
		};
		
		HasScopeExitInDtor e;
		
		throw 1;
	} catch (...) {	}
}
