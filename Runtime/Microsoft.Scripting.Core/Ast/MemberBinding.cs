/* ****************************************************************************
 *
 * Copyright (c) Microsoft Corporation. 
 *
 * This source code is subject to terms and conditions of the Apache License, Version 2.0. A 
 * copy of the license can be found in the License.html file at the root of this distribution. If 
 * you cannot locate the  Apache License, Version 2.0, please send an email to 
 * dlr@microsoft.com. By using this source code in any fashion, you are agreeing to be bound 
 * by the terms of the Apache License, Version 2.0.
 *
 * You must not remove this notice, or any other, from this software.
 *
 *
 * ***************************************************************************/

using System;
using System.Reflection;

#if CLR2
namespace Microsoft.Scripting.Ast {
#else
namespace System.Linq.Expressions {
#endif
    /// <summary>
    /// Describes the binding types that are used in MemberInitExpression objects.
    /// </summary>
    public enum MemberBindingType {
        /// <summary>
        /// A binding that represents initializing a member with the value of an expression.
        /// </summary>
        Assignment,
        /// <summary>
        /// A binding that represents recursively initializing members of a member.
        /// </summary>
        MemberBinding,
        /// <summary>
        /// A binding that represents initializing a member of type <see cref="System.Collections.IList"/> or <see cref="System.Collections.Generic.ICollection{T}"/> from a list of elements.
        /// </summary>
        ListBinding
    }

    /// <summary>
    /// Provides the base class from which the classes that represent bindings that are used to initialize members of a newly created object derive.
    /// </summary>
    public abstract class MemberBinding {
        MemberBindingType _type;
        MemberInfo _member;

        /// <summary>
        /// Initializes an instance of <see cref="MemberBinding"/> class.
        /// </summary>
        /// <param name="type">The type of member binding.</param>
        /// <param name="member">The field or property to be initialized.</param>
        [Obsolete("Do not use this constructor. It will be removed in future releases.")]
        protected MemberBinding(MemberBindingType type, MemberInfo member) {
            _type = type;
            _member = member;
        }

        /// <summary>
        /// Gets the type of binding that is represented.
        /// </summary>
        public MemberBindingType BindingType {
            get { return _type; }
        }

        /// <summary>
        /// Gets the field or property to be initialized.
        /// </summary>
        public MemberInfo Member {
            get { return _member; }
        }

        /// <summary>
        /// Returns a <see cref="String"/> that represents the current <see cref="Object"/>. 
        /// </summary>
        /// <returns>A <see cref="String"/> that represents the current <see cref="Object"/>. </returns>
        public override string ToString() {
            return ExpressionStringBuilder.MemberBindingToString(this);
        }
    }
}